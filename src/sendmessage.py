import boto3
client=boto3.client('sns','us-east-1')
client.publish(PhoneNumber='+17348900956',Message='Testing message sent from minor script')