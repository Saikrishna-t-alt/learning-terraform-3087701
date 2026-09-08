data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


module "sk_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "sk-iam-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]

  map_public_ip_on_launch = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "terraform-iam-lab"
  }
}

resource "aws_security_group" "sk_ec2_sg" {
  name        = "sk-iam-ec2-sg"
  description = "Security group for the IAM and EC2 Terraform lab"
  vpc_id      = module.sk_vpc.vpc_id

  # No inbound access is required because the instance
  # will be managed through AWS Systems Manager.

  egress {
    description = "Allow outbound access for AWS Systems Manager"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sk-iam-ec2-sg"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "sk_iam_instance" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  subnet_id = module.sk_vpc.public_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.sk_ec2_sg.id
  ]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.sk_ec2_profile.name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name        = "sk-iam-root-volume"
      Environment = "dev"
    }
  }

  tags = {
    Name        = "sk-iam-ec2-instance"
    Terraform   = "true"
    Environment = "dev"
    Purpose     = "IAM role and instance profile demonstration"
  }
}