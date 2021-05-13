# Creating variables to apply DRY using Terraform variable.tf
# These variables can be called in our main.tf

# ----- NAMES -----

variable "aws_vpc" {
  default = "eng84_jose_terraform_asg_vpc"
}

variable "aws_subnet_public" {
  default = "eng84_jose_terraform_public_subnet"
}

variable "aws_subnet_private" {
  default = "eng84_jose_terraform_private_subnet"
}

variable "aws_igw"{
  default = "eng84_jose_terraform_igw"
}

variable "aws_public_rt"{
  default = "eng84_jose_terraform_rt_public"
}

variable "aws_private_rt"{
  default = "eng84_jose_terraform_rt_private"
}

variable "aws_public_sg"{
  default = "eng84_jose_terraform_public_sg"
}

variable "aws_private_sg"{
  default = "eng84_jose_terraform_private_sg"
}

variable "aws_webapp" {
  default = "eng84_jose_terraform_nodeapp"
}

variable "webapp_ami_id" {
  default = "ami-01358d6e34043f36c"
}

variable "aws_db" {
  default = "eng84_jose_terraform_db"
}

variable "db_ami_id" {
  default = "ami-0486e8ec336543ed5"
}

# ----- IP -----

variable "aws_vpc_cidr" {
  default = "22.22.0.0/16"
}

variable "aws_public_cidr" {
  default = "33.33.1.0/24"
}

variable "aws_private_cidr" {
  default = "33.33.2.0/24"
}

variable "my_ip"{
  default = "109.153.93.183/32"
}

variable "webapp_ip"{
  default = "33.33.1.38"
}

variable "db_ip"{
  default = "33.33.2.122"
}

# ----- Key -----

variable "key" {
  default = "eng84devops"
}

variable "key_path" {
  default = "~/.ssh/eng84devops.pem"
}
