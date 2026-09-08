variable "aws_region" {
  description = "AWS Region where the Terraform resources will be created"
  type        = string
  default     = "ap-south-1"
}


variable "instance_type" {
  description = "EC2 instance type used for the IAM lab"
  type        = string
  default     = "t3.nano"

  validation {
    condition = contains(
      [
        "t3.nano",
        "t3.micro",
        "t3.small"
      ],
      var.instance_type
    )

    error_message = "The instance type must be t3.nano, t3.micro, or t3.small."
  }
}