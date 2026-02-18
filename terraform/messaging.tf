resource "aws_sns_topic" "strix_alerts" {
  name = "strix-security-alerts"

  tags = {
    Name = "strix-sns-alert"
  }
}

resource "aws_sns_topic_subscription" "strix_email" {
  topic_arn = aws_sns_topic.strix_alerts.arn
  protocol = "email"
  endpoint = var.sns_email_1
}
