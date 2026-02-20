resource "aws_apigatewayv2_api" "strix_api" {
  name          = "strix-webhook-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.strix_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.strix_git_hook.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "strix_route" {
  api_id = aws_apigatewayv2_api.strix_api.id
  route_key = "POST /"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "strix_staging" {
  api_id = aws_apigatewayv2_api.strix_api.id
  name = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_lambda" {
  statement_id = "AllowAPIGatwayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.strix_git_hook.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.strix_api.execution_arn}/*/*"
}
