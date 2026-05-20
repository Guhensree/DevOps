# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "${var.environment}-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
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
resource "aws_iam_policy" "cloudwatch_logging_policy" {
  name        = "${var.environment}-cloudwatch-logging-policy"
  description = "Allows writing logs to CloudWatch with least privilege"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        # Note: In strict production scenarios, the resource could be scoped down to specific log group ARNs.
        Resource = "*" 
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_policy_attach" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_logging_policy.arn
}
