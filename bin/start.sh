#!/bin/bash
set -e

# Setup dependencies
apt update && sudo apt install -y --no-install-recommends \
  jq curl awscli git docker.io

AWS_REGION=us-east-1

# Query for environment
ENVIRONMENT=$(aws ec2 describe-instances \
  --instance-id $(curl -s http://169.254.169.254/latest/meta-data/instance-id) \
  --query "Reservations[*].Instances[*].Tags[?Key=='Environment'].Value" \
  --region $AWS_REGION --output text)

# Define get value from parameter store
get_value() {
  aws ssm get-parameter --name $1 --with-decryption --region $AWS_REGION | jq -r '.Parameter.Value'
}

# Setup all environment variables for the application
MYSQL_HOST=$(get_value /$ENVIRONMENT/rds/hostname)
MYSQL_PORT=$(get_value /$ENVIRONMENT/rds/port)
MYSQL_USER=$(get_value /$ENVIRONMENT/rds/username)
MYSQL_PASSWORD=$(get_value /$ENVIRONMENT/rds/password)
MYSQL_DATABASE=$(get_value /$ENVIRONMENT/rds/database)

WORKDIR=/app
mkdir $WORKDIR && cd $WORKDIR && \
  git clone https://github.com/edgardoalz/devops-aws-ec2-challenge.git .

# Execute migrations
DATA_IMAGE=devops-data:latest
cd $WORKDIR/data && \
  docker build -t $DATA_IMAGE .

docker run -e DATABASE_DSN="mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DATABASE?verifyServerCertificate=false&useSSL=false&requireSSL=true" \
  -e DATABASE_PASSWORD="$MYSQL_PASSWORD" \
  -e DATABASE_USER="$MYSQL_USER" \
  -e FLYWAY_USAGE="migrate" \
  $DATA_IMAGE

# Execute application
APP_IMAGE=devops-app:latest
APP_PORT=8080
cd $WORKDIR/app && \
  docker build -t $APP_IMAGE .

docker run -d --restart=always -p $APP_PORT:$APP_PORT \
  -e MYSQL_USER="$MYSQL_USER" \
  -e MYSQL_PASSWORD="$MYSQL_PASSWORD" \
  -e MYSQL_HOST="$MYSQL_HOST" \
  -e MYSQL_PORT="$MYSQL_PORT" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  -e APP_PORT="$APP_PORT" \
  $APP_IMAGE

