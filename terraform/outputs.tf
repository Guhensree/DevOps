output "vpc_id" {
  description = "The ID of the Core VPC"
  value       = aws_vpc.core_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the Public Subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the Private Subnets"
  value       = aws_subnet.private[*].id
}

output "ec2_cloudwatch_role_arn" {
  description = "The ARN of the IAM Role for EC2 CloudWatch Logging"
  value       = aws_iam_role.ec2_cloudwatch_role.arn
}
