provider "aws" {
  region = "eu-central-1"
}

resource "aws_sns_topic" "my_sns_topic" {
  name = "tomers-topic"
 
}

output "sns_topic_arn" {
  value = aws_sns_topic.my_sns_topic.arn
}

resource "null_resource" "provisioner" {
  provisioner "local-exec" {
    environment = {
      SNS_TOPIC_ARN = aws_sns_topic.my_sns_topic.arn
    }
    command = <<-EOF
      #!/bin/bash
      SNS_TOPIC_ARN=$SNS_TOPIC_ARN
      sed "s/TopicArn=''/TopicArn='$SNS_TOPIC_ARN'/" preCode.py > postCode.py
    EOF
  }

  depends_on = [aws_sns_topic.my_sns_topic]
}


resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.my_sns_topic.arn
  protocol  = "email"
  endpoint  = "tomerschwartz2411@gmail.com"
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "postCode.py"
  output_path = "sumEvaluator.zip"
  depends_on = [null_resource.provisioner]
}

resource "aws_lambda_function" "my_lambda_function" {
  filename      = data.archive_file.lambda_code.output_path
  function_name = "sum-calc"
  role          = aws_iam_role.lambda_role.arn
  handler       = "postCode.lambda_handler"
  runtime       = "python3.9"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns-publish-policy"
  description = "Allows publishing to SNS topic"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.my_sns_topic.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sns_publish_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}



