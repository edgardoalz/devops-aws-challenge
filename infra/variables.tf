# Networking
variable "vpc_cidr" {
  type = string
}

variable "vpc_azs" {
  type = set(string)
}

variable "vpc_private_subnets" {
  type = set(string)
}

variable "vpc_public_subnets" {
  type = set(string)
}

variable "vpc_database_subnets" {
  type = set(string)
}

# Application
variable "app_port" {
  type = number
}
variable "ec2_instance_type" {
  type = string
}

# Database
variable "db_port" {
  type = number
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "rds_instance_class" {
  type = string
}

variable "rds_allocated_storage" {
  type = string
}