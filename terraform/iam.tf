resource "aws_iam_role" "strix_lambda" {
  name = "strix-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "strix-lambda-role"
  }
}

data "aws_iam_policy" "lambda_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach_lambda_access" {
  role = aws_iam_role.strix_lambda.name
  policy_arn = data.aws_iam_policy.lambda_access.arn
}

data "aws_iam_policy" "lambda_vpc" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach_vpc_access" {
  role = aws_iam_role.strix_lambda.name
  policy_arn = data.aws_iam_policy.lambda_vpc.arn
}

data "aws_iam_policy_document" "strix_s3_put" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.strix_scans.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "strix_db_put" {
  statement {
    actions = [
      "dynamodb:PutItem",
    ]

    resources = [
      aws_dynamodb_table.strix_db.arn,
    ]
  }
}

data "aws_iam_policy_document" "strix_sns_publish" {
  statement {
    actions = [
      "sns:Publish",
    ]

    resources = [
      aws_sns_topic.strix_alerts.arn,
    ]
  }
}

resource "aws_iam_policy" "s3_put" {
  name = "strix-s3-write"
  description = "Places reports in an S3 bucket"
  policy = data.aws_iam_policy_document.strix_s3_put.json
}

resource "aws_iam_policy" "db_put" {
  name = "strix-dynamodb-write"
  description = "Places reports in dynamodb"
  policy = data.aws_iam_policy_document.strix_db_put.json
}

resource "aws_iam_policy" "sns_publish" {
  name = "strix-sns-publish"
  description = "Publishes an SNS alert of the report"
  policy = data.aws_iam_policy_document.strix_sns_publish.json
}

resource "aws_iam_role_policy_attachment" "attach_s3_put" {
  role = aws_iam_role.strix_lambda.name
  policy_arn = aws_iam_policy.s3_put.arn
}

resource "aws_iam_role_policy_attachment" "attach_db_put" {
  role = aws_iam_role.strix_lambda.name
  policy_arn = aws_iam_policy.db_put.arn
}

resource "aws_iam_role_policy_attachment" "attach_sns_publish" {
  role = aws_iam_role.strix_lambda.name
  policy_arn = aws_iam_policy.sns_publish.arn
}
