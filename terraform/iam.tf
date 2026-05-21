data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_cloudwatch_role" {
  name               = "ec2-cloudwatch-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    
    # We constrain resources as much as possible, though the exact log group is not specified, 
    # we scope it to the current region.
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:*"]
  }
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "ec2-cloudwatch-logs-policy-${var.environment}"
  description = "Allow EC2 instances to write logs to CloudWatch"
  policy      = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_role_attachment" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}
