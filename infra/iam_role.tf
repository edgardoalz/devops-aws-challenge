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
    module.iam_policy_ec2.arn
  ]
  number_of_custom_role_policy_arns = 2
}

module "iam_policy_ec2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.3"

  name        = "policy-devops-${terraform.workspace}"
  path        = "/"
  description = "Access to EC2 instance"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": "ssm:StartSession",
        "Resource": "${module.ec2_instance.arn}"
    },
    {
      "Effect": "Allow",
      "Action": "ssm:TerminateSession",
      "Resource": "arn:aws:ssm:*:*:session/\$\{aws:username\}-*"
    }
  ]
}
EOF
}