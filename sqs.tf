#SQS
resource "aws_sqs_queue" "hotel_sqs" {
  name                      = "hotel_sqs"
  delay_seconds             = 2
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 2
  redrive_policy = jsonencode({
    deadLetterTargetArn = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_sqs_queue.terraform_queue_dlq.name}"
    maxReceiveCount     = 4
  })
}

#DLQ
resource "aws_sqs_queue" "terraform_queue_dlq" {
  name = "terraform-hotel-dlq"
  # redrive_allow_policy = jsonencode({
  #   redrivePermission = "byQueue", #allow specifies which source queues can access the dead-letter queue
  #   sourceQueueArns   = ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_sqs_queue.hotel_sqs.name}"]
  # })
}


# resource "aws_sqs_queue_policy" "sqs_policy_allow_lambda" {
#   queue_url = aws_sqs_queue.hotel_sqs.id
#   policy    = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#               "sqs:SendMessage",
#               "sqs:ChangeMessageVisibility"
#             ],
#             "Principal": {
#                 "Service": "lambda.amazonaws.com"
#                          },
#             "Condition": {
#               "ArnEquals": {
#                  "aws:SourceArn": "${module.recover_data.lambda_function.arn}"
#                             }
#                          },
#             "Effect": "Allow",
#             "Resource": "${aws_sqs_queue.hotel_sqs.arn}"
#         }
#     ]
# }
# EOF
# }


# Event source from SQS to lambda
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.hotel_sqs.arn
  enabled          = true
  function_name    = module.recover_data_sqs.lambda_function.arn
  batch_size       = 1
}