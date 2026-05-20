output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "ec2_iam_role_arn" {
  description = "The ARN of the least-privilege IAM role for EC2"
  value       = aws_iam_role.ec2_cloudwatch_role.arn
}
