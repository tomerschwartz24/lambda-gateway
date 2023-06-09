import json
import boto3
import os

def lambda_handler(event, context):
    #Get the two numbers provided by the user
    num1 = int(event['num1'])
    num2 = int(event['num2'])
    
    # Calculate the sum
    result = num1 + num2
    
    # Create an SNS client
    sns_client = boto3.client('sns')

    # Publish the result to the SNS topic
    sns_client.publish(
        TopicArn = os.environ['SNS_TOPIC_ARN'] ,
        Message=f"The sum of both numbers is: {result}"
    )
    
    # Response body
    response = {
        'statusCode': 200,
        'body': json.dumps({'result': result})
    }
    
    return response
