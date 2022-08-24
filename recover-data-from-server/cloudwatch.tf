resource "aws_cloudwatch_event_rule" "every_12_hours" {
  name                = "every-twelve-hours"
  description         = "Fires every twelve hours"
  schedule_expression = "rate(12 hours)"
}

resource "aws_cloudwatch_event_target" "check_foo_every_12_hours" {
  rule = aws_cloudwatch_event_rule.every_12_hours.name
  arn  = aws_lambda_function.lambda_resources.arn
}