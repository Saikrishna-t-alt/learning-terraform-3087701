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
  source = "terraform-aws-modules/vpc/aws"

  name = "dev"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]


  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "sk" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  subnet_id              = module.sk_vpc.public_subnets[0]
  vpc_security_group_ids = [module.sk_sg.security_group_id]

  tags = {
    Name = "Learning Terraform"
  }
}

module "sk_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  vpc_id  = module.sk_vpc.vpc_id
  name    = "sk"
  ingress_rules = ["https-443-tcp","http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}