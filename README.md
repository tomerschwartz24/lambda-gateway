# CloudBuzz Candidate task
## Serverless Lambda functiton that calculates the sum number of two numbers provided by the user in json format
## Tools : Lambda | AWS SNS | IAM | PYTHON | API GATEWAY


Interviewer has been subscribed to the SNS topic and can execute the Lambda function by running : 
```
curl -X POST -H "Content-Type: application/json" -d '{"num1": 5, "num2": 5}' https://am2rtyixs3.execute-api.eu-central-1.amazonaws.com/Executor-Main/
```
### Response body example : 
```
{"statusCode": 200, "body": "{\"result\": 10}"}%    
```

### Response email example :  <br>
<img src="emailresponse.png" alt="alt text" width="500" height="100"> <br>





## Architecture 
<img src="Architecture.png" alt="alt text" width="600" height="500">

