#!/bin/bash

FUNCTION_NAME=recover-data-sqs
DEFAULT_REGION=eu-west-1
HANDLER_2=recover-data-from-sqs/lambda.handler
QUEUE_NAME=hotel_sqs
SQS_QUEUE_URL=http://localhost:4576/000000000000/hotel_sqs


echo "Create SQS queue hotel_sqs"
aws sqs create-queue  --endpoint-url http://localhost:4566 \
    --region ${DEFAULT_REGION} \
    --queue-name ${QUEUE_NAME} \
 

echo "Send message to SQS queue hotel_sqs"
aws sqs send-message --endpoint-url=http://localhost:4566 \
    --queue-url http://localhost:4576/000000000000/${QUEUE_NAME} \
    --region ${DEFAULT_REGION} --message-body 'Test Message!'  


echo "Create Lambda function"
awslocal lambda create-function \
    --code S3Bucket="__local__",S3Key="${LOCAL_CODE_PATH}" \
    --function-name ${FUNCTION_NAME} \
    --runtime nodejs16.x \
    --timeout 5 \
    --handler ${HANDLER_2}  \
    --role dev \
    --environment "{\"Variables\":{\"sqs_queue_url\":\"${SQS_QUEUE_URL}\"}}"

echo "create sqs event source mapping for the lambda"
awslocal lambda create-event-source-mapping \
    --event-source-arn arn:aws:sqs:${DEFAULT_REGION}:000000000000:${QUEUE_NAME} \
    --function-name ${FUNCTION_NAME} \
    --enabled    

#TO TEST manually
#aws sqs send-message --endpoint-url=http://localhost:4566 --queue-url http://localhost:4576/000000000000/hotel_sqs --region eu-west-1  --message-body 'ZZZZZZZZZZZZZZZZ!' 