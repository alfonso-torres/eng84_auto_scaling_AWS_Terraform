# Let's initialise terraform
# Providers?
# AWS

# This code will eventually create ALB and Auto Scaling Group with the app instance

provider "aws"{
# define the region to launch the ec2 instance in Ireland	
	region = "eu-west-1"
}

# Creating a VPC
resource "aws_vpc" "jose_terraform_asg_vpc"{
 cidr_block = var.aws_vpc_cidr
 instance_tenancy = "default"

 tags = {
   Name = "${var.aws_vpc}"
 }
}

# Creating an internet gateway
resource "aws_internet_gateway" "jose_terraform_asg_igw" {
  vpc_id = aws_vpc.jose_terraform_asg_vpc.id

  tags = {
    Name = var.aws_igw
  }
}

# Editing the main Route Table
resource "aws_default_route_table" "jose_terraform_asg_rt_public" {
  default_route_table_id = aws_vpc.jose_terraform_asg_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jose_terraform_asg_igw.id
  }

  tags = {
    Name = var.aws_public_rt
  }
}

# Creating Public Subnet 1 - AZ1
resource "aws_subnet" "jose_terraform_asg_public_subnet1" {
  vpc_id = aws_vpc.jose_terraform_asg_vpc.id
  cidr_block = var.aws_public1_cidr
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.aws_subnet_public}-1"
  }
}

# Creating Public Subnet 2 - AZ2
resource "aws_subnet" "jose_terraform_asg_public_subnet2" {
  vpc_id = aws_vpc.jose_terraform_asg_vpc.id
  cidr_block = var.aws_public2_cidr
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.aws_subnet_public}-2"
  }
}

# Associating main route table with public subnets
resource "aws_route_table_association" "jose_terraform_asg_asoc1" {
  subnet_id = aws_subnet.jose_terraform_asg_public_subnet1.id
  route_table_id = aws_vpc.jose_terraform_asg_vpc.default_route_table_id
}

resource "aws_route_table_association" "jose_terraform_asg_asoc2" {
  subnet_id = aws_subnet.jose_terraform_asg_public_subnet2.id
  route_table_id = aws_vpc.jose_terraform_asg_vpc.default_route_table_id
}

# Creating Private Route Table
resource "aws_route_table" "jose_terraform_asg_rt_private" {
  vpc_id = aws_vpc.jose_terraform_asg_vpc.id

  tags = {
    Name = var.aws_private_rt
  }
}

# Creating Private Subnet - AZ1
resource "aws_subnet" "jose_terraform_asg_private_subnet" {
  vpc_id = aws_vpc.jose_terraform_asg_vpc.id
  cidr_block = var.aws_private_cidr
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.aws_subnet_private}"
  }
}

# Associating private route table with private subnet
resource "aws_route_table_association" "jose_terraform_asg_asoc3" {
  subnet_id = aws_subnet.jose_terraform_asg_private_subnet.id
  route_table_id = aws_route_table.jose_terraform_asg_rt_private.id
}

# Creating security group for app
resource "aws_security_group" "jose_terraform_asg_public_sg" {
 name = var.aws_public_sg
 description = "App security group from Terraform"
 vpc_id = aws_vpc.jose_terraform_asg_vpc.id

 # Inbound rules for our app
 # Inbound rules code block:
 ingress {
  from_port = "80" # for our to launch in the browser
  to_port = "80" # for our to launch in the browser
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allow all
 }

 ingress {
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = [var.my_ip]
  description = "Allow admin to SSH"
 }
 # Inbound rules code block ends

 # Outbound rules code block
 egress{
  from_port = 0
  to_port = 0
  protocol = "-1" # allow all
  cidr_blocks = ["0.0.0.0/0"]
 }
 # Outbound rules code block ends
}

# Creating security group for db
resource "aws_security_group" "jose_terraform_asg_private_sg" {
  name = var.aws_private_sg
  description = "Db security group from Terraform"
  vpc_id = aws_vpc.jose_terraform_asg_vpc.id

  ingress {
    from_port         = "22"
    to_port           = "22"
    protocol          = "tcp"
    cidr_blocks       = [var.my_ip]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.jose_terraform_asg_public_sg.id]
    description = "Allow all traffic from the app"
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating DB instance
resource "aws_instance" "db_instance"{
  # add the AMI id between "" as below
  ami = var.db_ami_id

  # Let's add the type of instance we would like launch
  instance_type = "t2.micro"

  # Subnet
  subnet_id = aws_subnet.jose_terraform_asg_private_subnet.id

  private_ip = var.db_ip

  # Security group
  vpc_security_group_ids = [aws_security_group.jose_terraform_asg_private_sg.id]

  # Do we need to enable public IP for our app
  associate_public_ip_address = true

  key_name = var.key

  # Tags is to give name to our instance
  tags = {
    Name = "${var.aws_db}"
  }
}

# Creating the Application Load Balancer
resource "aws_lb" "jose_terraform_asg_load_balancer" {
  name               = "eng84-jose-terraform-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  security_groups    = [aws_security_group.jose_terraform_asg_public_sg.id]
  subnets            = [aws_subnet.jose_terraform_asg_public_subnet1.id, aws_subnet.jose_terraform_asg_public_subnet2.id]
}

# Creating the target group:
resource "aws_lb_target_group" "jose_terraform_asg_target_group" {
  name     = "eng84-jose-terraform-tg-app"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.jose_terraform_asg_vpc.id
}

# Creating a listener
resource "aws_lb_listener" "jose_terraform_asg_listener" {
  load_balancer_arn = aws_lb.jose_terraform_asg_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jose_terraform_asg_target_group.arn
  }

  depends_on = [aws_lb_target_group.jose_terraform_asg_target_group, aws_lb.jose_terraform_asg_load_balancer]
}

# Creating launch template for Auto Scaling Group
resource "aws_launch_template" "jose_terraform_asg_launch_template" {
  name          = "eng84_jose_terraform_autosg_lt"
  description = "template for web application"
  ebs_optimized = false
  image_id      = var.webapp_ami_id
  instance_type = "t2.micro"
  key_name = var.key

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = [aws_security_group.jose_terraform_asg_public_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eng84_jose_terraform_autosg_app"
    }
  }
  
  # Running the provision file when a new instance is launched
  user_data = filebase64("./scripts/init.sh")
}

# Creating Auto Scaling Group
resource "aws_autoscaling_group" "jose_terraform_auto_scaling_group" {
  name = "eng84_jose_terraform_autosg"
  desired_capacity = 2
  max_size         = 2
  min_size         = 2
  
  # Heath checks
  health_check_grace_period = 50
  health_check_type         = "ELB"
  force_delete = true

  # Attaching load balancer in the form of a target group
  target_group_arns = [aws_lb_target_group.jose_terraform_asg_target_group.arn]

  vpc_zone_identifier = [aws_subnet.jose_terraform_asg_public_subnet1.id, aws_subnet.jose_terraform_asg_public_subnet2.id]

  # Launching template the last version
  launch_template {
    id      = aws_launch_template.jose_terraform_asg_launch_template.id
    version = "$Latest"
  }

  depends_on = [aws_launch_template.jose_terraform_asg_launch_template]
}
