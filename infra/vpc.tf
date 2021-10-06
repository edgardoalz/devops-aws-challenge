module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-devops-${terraform.workspace}"
  
  cidr             = var.vpc_cidr
  azs              = var.vpc_azs
  private_subnets  = var.vpc_private_subnets
  public_subnets   = var.vpc_public_subnets
  database_subnets = var.vpc_database_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false
}