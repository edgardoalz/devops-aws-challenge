# Networking
vpc_cidr             = "10.245.0.0/16"
vpc_azs              = ["us-east-1a", "us-east-1b"]
vpc_private_subnets  = ["10.245.1.0/24", "10.245.2.0/24"]
vpc_public_subnets   = ["10.245.3.0/24", "10.245.4.0/24"]
vpc_database_subnets = ["10.245.5.0/24", "10.245.6.0/24"]

# Application
app_port = 8080
ec2_instance_type = "t2.micro"

# Database
db_port = 3306
rds_instance_class = "db.t2.micro"
rds_allocated_storage = 5