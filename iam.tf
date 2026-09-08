data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid    = "AllowEC2ToAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}



resource "aws_iam_role" "sk_ec2_role" {
  name = "sk-terraform-ec2-ssm-role"

  description = "IAM role used by the Terraform IAM lab EC2 instance"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name        = "sk-terraform-ec2-ssm-role"
    Terraform   = "true"
    Environment = "dev"
    Purpose     = "EC2 Systems Manager access"
  }
}


resource "aws_iam_role_policy_attachment" "sk_ssm_policy_attachment" {
  role = aws_iam_role.sk_ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "sk_ec2_profile" {
  name = "sk-terraform-ec2-ssm-profile"
  role = aws_iam_role.sk_ec2_role.name

  tags = {
    Name        = "sk-terraform-ec2-ssm-profile"
    Terraform   = "true"
    Environment = "dev"
  }
}