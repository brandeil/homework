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

#get the connection string from the RDS postgresDB instance
postgresDB="sqlite:////home/ubuntu/airflow/airflow.db"

# ssh into the EC2 ; run additional script
echo "ssh into EC2 and run airflow installation script"
#ssh -i "homework.pem" -o StrictHostKeyChecking=no ubuntu@54.208.58.41 'bash -s' < install_airflow.sh $postgresDB
ssh -i "homework.pem" -o StrictHostKeyChecking=no $connectUser$PublicIp 'bash -s' < install_airflow.sh $postgresDB
