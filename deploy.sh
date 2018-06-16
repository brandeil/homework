#!/bin/bash

#copy cloud formation template files to S3 bucket
echo "copy cloud formation template to s3"
aws s3 cp ./cloudformation/airflow.cloudFormation s3://lb-mybucket-aws

# create the cloud formation stack
#echo "create the cloud formation stack"
#aws cloudformation create-stack --stack-name "airflow" --template-url "https://s3.amazonaws.com/lb-mybucket-aws/airflow.cloudFormation"

# get the newly created EC2 instance ID
aws cloudformation describe-stacks --query 'Stacks[0].Outputs[?OutputKey==`MyEC2`].OutputValue' --output text


# remote into the EC2 and use sed to update ~/airflow/airflow.cfg to values from AWS resources
#sql_alchemy_conn=
#base_url=
#web_server_host
#web_server_port
#broker_url
#celery_result_backend



# initialize the database
#airflow initdb

# start the web server, default port is 8080
#airflow webserver -p 8080

