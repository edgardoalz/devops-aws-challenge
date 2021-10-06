module "sg_ec2_instance" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_app_devops_${terraform.workspace}"
  description = "Security group for application"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      description = "Application ports"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  egress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.sg_rds_instance.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["http-80-tcp", "https-443-tcp"]
}

module "sg_rds_instance" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_db_devops_${terraform.workspace}"
  description = "Security group for database"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.sg_ec2_instance.security_group_id
    },
  ]
}