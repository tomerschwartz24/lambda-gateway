import json

def lambda_handler(event, context):

    body = json.loads(event['body'])
    
    num1 = body['num1']
    num2 = body['num2']
    
    result = num1 + num2
    
    response = {
        'statusCode': 200,
        'body': json.dumps({'result': result})
    }
    
    return response
