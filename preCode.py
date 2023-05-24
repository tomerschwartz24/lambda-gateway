import json
import boto3

def lambda_handler(event, context):
    #Get the two numbers provided by the user
    num1 = event['num1']
    num2 = event['num2']
    
    # Calculate the sum
    result = num1 + num2
    
    # Create an SNS client
    sns_client = boto3.client('sns')

    # Publish the result to the SNS topic
    sns_client.publish(
        TopicArn='',
        Message=f"The sum of both numbers is: {result}"
    )
    
    # Response body
    response = {
        'statusCode': 200,
        'body': json.dumps({'result': result})
    }
    
    return response
