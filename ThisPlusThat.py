import json
import boto3


#initalize a lamba function that reads the provided numbers
def lambda_handler(event, context):
    num1 = event['num1']
    num2 = event['num2']
    
    # Calculate the sum of the provided numbers by the user
    result = num1 + num2
    
    # Use SNS library to connect to the AWS sns 
    sns_client = boto3.client('sns')

    # Push the result to the AWS SNS service 
    sns_client.publish(
        #The topic I created
        TopicArn='arn:aws:sns:eu-central-1:384005890259:cb-task-tomer',
        Message=str(result)
    )
    
    # Result response 
    response = {
        'statusCode': 200,
        'body': json.dumps({'result': result})
    }
    
    return response
