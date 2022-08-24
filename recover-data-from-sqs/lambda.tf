
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda.js"
  output_path = "zipped/recover-sqs.zip"
}

resource "aws_lambda_function" "lambda_resources" {
  filename         = "zipped/recover-sqs.zip"
  function_name    = "recover-data-sqs"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "lambda.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs12.x"
  environment {
    variables = var.environment
  }
}