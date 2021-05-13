# Let's initialise terraform
# Providers?
# AWS

# This code will eventually create ALB and Auto Scaling Group with the app instance

provider "aws"{
# define the region to launch the ec2 instance in Ireland	
	region = "eu-west-1"
}

# Create a VPC
resource "aws_vpc" "jose_terraform_vpc_"{
 cidr_block = var.aws_vpc_cidr
 instance_tenancy = "default"

 tags = {
   Name = "${var.aws_vpc}"
 }
}
