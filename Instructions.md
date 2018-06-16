#
To run the automation, execute the below command;  it will create a new cloud formation stack, wait for resources to complete provisioning
ssh to the newly created EC2 and modify the airflow.cfg file to point to the newly created resources in AWS
finally, it will invoke the Airflow application
#
sh ./deploy.sh

