module "recover_data" {
  source = "./recover-data-from-server"
  environment = {
    sqs_queue_url = aws_sqs_queue.hotel_sqs.id
  }
}

module "recover_data_sqs" {
  source = "./recover-data-from-sqs"
  environment = {
    sqs_queue_url = aws_sqs_queue.hotel_sqs.id
  }
}