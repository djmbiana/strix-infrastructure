 # packaging lambda function
 data "archive_file" "sns_to_slack" {
   type = "zip"
   source_file = "${path.module}/../lambda-code/strixSlackSNS.js"
   output_path = "${path.module}/strix-slack-sns.zip"
 }

 resource "aws_lambda_function" "slack_publish_sns" {
   filename = data.archive_file.sns_to_slack.output_path
   function_name = "strix-slack-sns"
   role = aws_iam_role.strix_lambda.arn
   handler = "strixSlackSNS.handler"
   runtime = "nodejs20.x"

   environment {
     variables = {
       SLACK_WEBHOOK_URL = var.slack_webhook_url
     }
   }
 }


 data "archive_file" "strix_git_api" {
   type = "zip"
   source_file = "${path.module}/../lambda-code/strixGitHook.js"
   output_path = "${path.module}/strix-git-hook.zip"
 }

 resource "aws_lambda_function" "strix_git_hook" {
   filename = data.archive_file.strix_git_api.output_path
   function_name = "strix-git-hook"
   role = aws_iam_role.strix_lambda.arn
   handler = "strixGitHook.handler"
   timeout = 30
   runtime = "nodejs20.x"

   environment {
     variables = {
       SCAN_RESULTS_BUCKET = aws_s3_bucket.strix_scans.id
     }
   }

  vpc_config {
    subnet_ids = [aws_subnet.strix_private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
 }
