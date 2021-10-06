data aws_caller_identity caller {}
data aws_region region {}
module "iam_role_ec2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.3"

  trusted_role_arns = []

  trusted_role_services = ["ec2.amazonaws.com"]

  create_role = true
  create_instance_profile = true

  role_name         = "role-devops-${terraform.workspace}"
  role_requires_mfa = false

  custom_role_policy_arns = [
    module.iam_policy_ec2.arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  number_of_custom_role_policy_arns = 2
}

module "iam_policy_ec2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.3"

  name        = "policy-devops-${terraform.workspace}"
  path        = "/"
  description = "Access to EC2 instance"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
          Effect = "Allow",
          Action = "ec2:DescribeInstances",
          Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "ssm:GetParameters",
        Resource = "arn:aws:ssm:${data.aws_region.region.name}:${data.aws_caller_identity.caller.account_id}:parameter/${terraform.workspace}/*"
      }
    ]
  })
}