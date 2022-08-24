
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda.js"
  output_path = "zipped/lambda.zip"
}

resource "aws_lambda_function" "lambda_resources" {
  filename         = "zipped/lambda.zip"
  function_name    = "recover-data-server"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "lambda.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs12.x"

  environment {
    variables = var.environment
  }
}