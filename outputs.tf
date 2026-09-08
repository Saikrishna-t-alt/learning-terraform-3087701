output "vpc_id" {
  description = "ID of the VPC created by Terraform"
  value       = module.sk_vpc.vpc_id
}


output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.sk_vpc.public_subnets
}


output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.sk_iam_instance.id
}


output "ec2_instance_state" {
  description = "Current state of the EC2 instance"
  value       = aws_instance.sk_iam_instance.instance_state
}


output "iam_role_name" {
  description = "Name of the IAM role attached to the EC2 instance"
  value       = aws_iam_role.sk_ec2_role.name
}


output "iam_role_arn" {
  description = "ARN of the IAM role attached to the EC2 instance"
  value       = aws_iam_role.sk_ec2_role.arn
}


output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.sk_ec2_profile.name
}


output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.sk_ec2_profile.arn
}


output "ssm_managed_policy_arn" {
  description = "ARN of the AWS-managed Systems Manager policy"
  value       = aws_iam_role_policy_attachment.sk_ssm_policy_attachment.policy_arn
}


output "selected_ami_id" {
  description = "ID of the Amazon Linux 2023 AMI selected by Terraform"
  value       = data.aws_ami.app_ami.id
}