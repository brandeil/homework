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
#dbconnstring="sqlite:////home/ubuntu/airflow/airflow.db"
rdsEndpoint=$(aws rds describe-db-instances --query 'DBInstances[0].Endpoint.Address' --output text)
dbconnstring="postgresql+psycopg2://DBUser:DBPassword@$rdsEndpoint:5432/airflow_db"

# build up the installation script
echo -e '#!/bin/bash' >> airflow_install.sh
echo 'export AIRFLOW_HOME=/home/ubuntu/airflow' >> airflow_install.sh
echo 'export AIRFLOW__CORE__SQL_ALCHEMY_CONN='$dbconnstring >> airflow_install.sh
echo 'sudo -H pip install apache-airflow[postgres, redis]' >> airflow_install.sh
echo '# initialize the database' >> airflow_install.sh
echo 'airflow initdb' >> airflow_install.sh
echo '# start the web server, default port is 8080' >> airflow_install.sh
echo 'airflow webserver -p 8080' >> airflow_install.sh


# ssh into the ec2 and copy the airflow_install script
echo "ssh and copy script"
scp -i "homework.pem" -o StrictHostKeyChecking=no airflow_install.sh $connectUser$PublicIp:/home/ubuntu/.

# ssh into the EC2 ; run additional script
echo "ssh into EC2 and run airflow installation script"
ssh -i "homework.pem" -o StrictHostKeyChecking=no $connectUser$PublicIp "./airflow_install.sh"

rm airflow_install.sh