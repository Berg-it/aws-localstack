'use strict';

const https = require('https');
let AWS = require('aws-sdk');

let queueUrl = process.env.sqs_queue_url
let sqs = new AWS.SQS({
    region: process.env.AWS_REGION
});

exports.handler = (event, context, callback) => {
    console.log('Hello, logs!');

    var params = {
        MessageBody: JSON.stringify({  realmID: "123",entities: event.body}),
        QueueUrl: queueUrl
      };

      sqs.sendMessage(params, function(err, data) {
        if (err) {
          console.log('error:', "failed to send message" + err);
          callback(null, {statusCode: 500, body: 'Internal Service Error'});
        } else {
          callback(null, {statusCode: 200, body: JSON.stringify(data)});
          console.log('data:' + data.MessageId);
          console.log('Sent to ' + queueUrl);
          console.log(data.MessageId);
        }
        console.log('after the send logic');
      });  
}