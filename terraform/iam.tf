# iam.tf

# 1. Create the IAM Role for the compute service
resource "aws_iam_role" "app_role" {
  name = "airman-app-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" # Assuming we deploy to EC2
        }
      }
    ]
  })
}

# 2. Define a least-privilege policy (e.g., only allowing it to write logs)
resource "aws_iam_policy" "app_logging_policy" {
  name        = "airman-app-logging-${var.environment}"
  description = "Allows the application to write logs to CloudWatch"

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

# 3. Attach the strict policy to the role
resource "aws_iam_role_policy_attachment" "app_logging_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_logging_policy.arn
}
