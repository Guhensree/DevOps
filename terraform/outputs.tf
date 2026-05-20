# outputs.tf

output "vpc_id" {
  description = "The ID of the generated VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "app_iam_role_arn" {
  description = "The ARN of the least-privilege application role"
  value       = aws_iam_role.app_role.arn
}
