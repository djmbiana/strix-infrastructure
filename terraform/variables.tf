variable "sns_email_1" {
  description = "Email for security alerts"
  type = string
  sensitive = true
}

variable "slack_webhook_url" {
  description = "Slack API for SNS integration"
  type = string
  sensitive = true
}
