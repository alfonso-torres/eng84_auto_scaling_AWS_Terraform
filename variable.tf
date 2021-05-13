# Creating variables to apply DRY using Terraform variable.tf
# These variables can be called in our main.tf

# ----- NAMES -----

variable "aws_vpc" {
  default = "eng84_jose_terraform_autosg_vpc"
}

variable "aws_subnet_public" {
  default = "eng84_jose_terraform_autosg_public_subnet"
}

variable "aws_subnet_private" {
  default = "eng84_jose_terraform_autosg_private_subnet"
}

variable "aws_igw"{
  default = "eng84_jose_terraform_autosg_igw"
}

variable "aws_public_rt"{
  default = "eng84_jose_terraform_autosg_rt_public"
}

variable "aws_private_rt"{
  default = "eng84_jose_terraform_autosg_rt_private"
}

variable "aws_public_sg"{
  default = "eng84_jose_terraform_autosg_public_sg"
}

variable "aws_private_sg"{
  default = "eng84_jose_terraform_autosg_private_sg"
}

variable "aws_webapp" {
  default = "eng84_jose_terraform_autosg_nodeapp"
}

variable "webapp_ami_id" {
  default = "ami-01358d6e34043f36c"
}

variable "aws_db" {
  default = "eng84_jose_terraform_autosg_db"
}

variable "db_ami_id" {
  default = "ami-0486e8ec336543ed5"
}

# ----- IP -----

variable "aws_vpc_cidr" {
  default = "54.54.0.0/16"
}

variable "aws_public1_cidr" {
  default = "54.54.1.0/24"
}

variable "aws_public2_cidr" {
  default = "54.54.2.0/24"
}

variable "aws_private_cidr" {
  default = "54.54.3.0/24"
}

variable "my_ip"{
  default = "xxxx"
}

variable "db_ip"{
  default = "54.54.3.82"
}

# ----- Key -----

variable "key" {
  default = "eng84devops"
}

variable "key_path" {
  default = "~/.ssh/eng84devops.pem"
}
