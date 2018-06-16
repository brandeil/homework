#
High-Level Approach
1) Create CloudFormation scripts to provision web server on EC2 , PostgreSQL DB on RDS , and Redis cluster on Elasticache.
***the EC2 bootstrap script will contain OS updates and installation of pip manager and 'apache-airflow' package

2) Create Bash Script that will 
	a)use the AWS CLI to create a CloudFormation stack pointing to the cloudFormation template bucket location
	b)Update the configuration variables in ~/airflow/airflow.cfg configuration file 
	c)Start the airflow webserver

#
Assumptions
1) We will be deploying to an existing VPC on region: eu-west-1 and all core services will already be provisioned such as VPC, Subnets, IAM roles, NACLs, security groups, etc and a pre-existing security group will be available to select.

#
Known Deviations from Best Practice or Production Setup:
1) The web server will run on a single EC2 in a single availability zone.  In a real production setup, there would be multiple EC2s running on at least 2 availability zones behind a load balancer and an AutoScaling group.

2) It might be a good idea to use an AMI that has python, pip manager, etc pre-installed instead of using a base Linux images provided by AWS

3) A Configuration management tool such as Ansible/Puppet would be a much better approach instead of embedding start up scripts on the EC2.  For example,  the web software could be deployed to any distribution of Linux whereas the User data scripts (as coded) will only work on Ubuntu.
For the sake of time,  using User Data is faster as opposed to creating the tasks of configuring a Puppet master and building out the modules required.
That is the only reason for using User Data scripts.

4) Database should use multi-az failover for production environment to ensure high-availability.

5) Cloud formation script is hardcoding a number of values because of time constraints.  Ideally, there should be parameters with default values or mappings by environment.