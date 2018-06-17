#!/bin/bash

#copy cloud formation template files to S3 bucket
echo "copy cloud formation template to s3"
aws s3 cp ./cloudformation/airflow.cloudFormation s3://lb-mybucket-aws


#aws cloudformation delete-stack --stack-name "airflow" 

# create the cloud formation stack
#checkstatus=$(aws cloudformation describe-stacks --stack-name airflow --query 'Stacks[0].StackStatus')
#echo $checkstatus
#if [ $checkstatus == "CREATE_COMPLETE" ]; then
# echo 'stack exists; updating....'
# aws cloudformation update-stack --stack-name "airflow" --template-url "https://s3.amazonaws.com/lb-mybucket-aws/airflow.cloudFormation"
#else
# echo 'stack does not exist; creating...'
# aws cloudformation create-stack --stack-name "airflow" --template-url "https://s3.amazonaws.com/lb-mybucket-aws/airflow.cloudFormation"
#fi

aws cloudformation create-stack --stack-name "airflow" --template-url "https://s3.amazonaws.com/lb-mybucket-aws/airflow.cloudFormation"

echo 'waiting for stack to complete...'
aws cloudformation wait stack-create-complete --stack-name airflow
echo 'stack is completed'

# get the newly created EC2 instance ID
Ec2InstanceID=$(aws cloudformation describe-stacks --stack-name airflow --query 'Stacks[0].Outputs[?OutputKey==`MyEC2`].OutputValue' --output text)
echo $Ec2InstanceID

PublicIp=$(aws ec2 describe-instances --instance-ids $Ec2InstanceID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
echo $PublicIp

connectUser="ubuntu@"

echo $connectUser$PublicIp

# remote into the EC2 
# use sed to update ./airflow/airflow.cfg to values from AWS resources
#echo "ssh into EC2"
#ssh -i "homework.pem" -o StrictHostKeyChecking=no $connectUser$PublicIp "sudo sed -i 's/sql_alchemy_conn = .*/sql_alchemy_conn = changed/' /home/ubuntu/airflow/airflow.cfg"
#echo "successful ssh"


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

