High-Level Approach
1) Create CloudFormation scripts to provision web server on EC2 , PostgreSQL DB on RDS , Redis cluster on Elasticache, and S3 bucket to store the same scripts.
***the EC2 bootstrap script will contain OS updates as installation of pip manager and installation of 'apache-airflow' package

2) Create Bash Script that will 
	a)use the AWS CLI to create a CloudFormation stack pointing to the cloudFormation template bucket location in step 1
	b)Update the configuration variables in ~/airflow/airflow.cfg configuration file 
	c)Start the airflow webserver


Assumptions
1) We will be deploying to an existing VPC on region: eu-west-1 and all core services will already be provisioned such as VPC, Subnets, IAM roles, NACLs, security groups, etc and a pre-existing security group will be available to select.

Known Deviations from Best Practice or Production Setup:
1) The web server will run on a single EC2 in a single availability zone.  In a real production setup, there would be multiple EC2s running on at least 2 availability zones behind a load balancer and an AutoScaling group.

2) It might be a good idea to use an AMI that has python, pip manager, etc pre-installed instead of using a base Linux images provided by AWS

3) A Configuration management tool such as Ansible could be used to provision new instances of EC2 rather than using an AMI.

4) Database should use multi-az failover for production environment