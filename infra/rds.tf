module "rds_instance" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "rds-devops-${terraform.workspace}"

  engine            = "mysql"
  engine_version    = "5.7.19"
  family            = "mysql5.7"
  major_engine_version = "5.7"
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage

  name     = "devops_${terraform.workspace}"
  username = "devops"
  password = var.db_password
  port     = var.db_port

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.sg_rds_instance.security_group_id]
  subnet_ids = module.vpc.database_subnets

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval = "30"
  monitoring_role_name = "${terraform.workspace}RDSMonitoringRole"
  create_monitoring_role = true




  deletion_protection = false
  parameters = []
  options = []
}

resource "aws_ssm_parameter" "rds_database" {
  name = "/${terraform.workspace}/rds/database"
  type = "String"
  value = module.rds_instance.db_instance_name
}

resource "aws_ssm_parameter" "rds_username" {
  name = "/${terraform.workspace}/rds/username"
  type = "SecureString"
  value = module.rds_instance.db_instance_username
}

resource "aws_ssm_parameter" "rds_hostname" {
  name = "/${terraform.workspace}/rds/hostname"
  type = "String"
  value = module.rds_instance.db_instance_address
}

resource "aws_ssm_parameter" "rds_password" {
  name = "/${terraform.workspace}/rds/password"
  type = "SecureString"
  value = module.rds_instance.db_instance_password
}

resource "aws_ssm_parameter" "rds_port" {
  name = "/${terraform.workspace}/rds/port"
  type = "String"
  value = module.rds_instance.db_instance_port
}