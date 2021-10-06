data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "i-devops-${terraform.workspace}"
  iam_instance_profile = module.iam_role_ec2.iam_instance_profile_id

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_instance_type
  monitoring             = true
  vpc_security_group_ids = [module.sg_ec2_instance.security_group_id]
  subnet_id              = module.vpc.database_subnets[0]

  user_data = file("${path.module}/../bin/start.sh")
}