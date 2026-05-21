output "vpc_id" {
  description = "The ID of the Core VPC"
  value       = aws_vpc.core_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the Public Subnets"
  value       = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "ec2_iam_role_arn" {
  description = "The ARN of the EC2 IAM role with CloudWatch logs permissions"
  value       = aws_iam_role.ec2_cloudwatch_role.arn
}
