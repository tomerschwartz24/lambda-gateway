provider "aws" {
  region = "eu-central-1"  # Update with your desired region
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


