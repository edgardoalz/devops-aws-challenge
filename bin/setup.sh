#!/bin/bash
set -e

WORKDIR=$(pwd)

if [ -z "$ENVIRONMENT" ]; then
  echo "ENVIRONMENT not set to apply"
  exit 1
fi

cd $WORKDIR/infra && terraform init

terraform workspace select $ENVIRONMENT > /dev/null 2>&1

if [ $? -eq  1 ]; then
  terraform workspace new $ENVIRONMENT
fi

terraform plan -var-file=config/$ENVIRONMENT.tfvars