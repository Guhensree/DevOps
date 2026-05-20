# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "${var.environment}-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# IAM Policy for CloudWatch Logging (Least Privilege)
resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "${var.environment}-cloudwatch-logs-policy"
  description = "Allows EC2 instances to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_attach" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# IAM Instance Profile to attach the role to an EC2 instance later
resource "aws_iam_instance_profile" "ec2_cloudwatch_profile" {
  name = "${var.environment}-ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}
