#
High-Level Approach
1) Create CloudFormation scripts to provision web server on EC2 , PostgreSQL DB on RDS , and Redis cluster on Elasticache.

2) Create Bash Script that will 
	a)use the AWS CLI to create a CloudFormation stack pointing to the cloudFormation template bucket location
	b)Install the airflow package; update the configuration variables in ~/airflow/airflow.cfg configuration file 
	c)Start the airflow webserver

#
Assumptions
1) We will be deploying to an existing VPC on region: eu-west-1 and all core services will already be provisioned such as VPC, Subnets, IAM roles, NACLs, security groups, etc and a pre-existing security group will be available to select.

#
Known Deviations from Best Practice or Production Setup:
1) The web server will run on a single EC2 in a single availability zone.  In a real production setup, there would be multiple EC2s running on at least 2 availability zones behind a load balancer and an AutoScaling group.

2) It might be a good idea to use an AMI that has python, pip manager, etc pre-installed instead of using a base Linux images provided by AWS

3) A Configuration management tool such as Ansible/Puppet would be another approach to deploying out the airflow software to the EC2 instances.

4) Database should use multi-az failover for production environment to ensure high-availability.

5) Cloud formation script is hardcoding a number of values because of time constraints.  Ideally, there should be parameters with default values or mappings by environment.

#
Ideal strategy
1) Provision cloud resources using AWS CloudFormation or Terraform

2) Create Docker image to host the airflow application.  The Dockerfile would be similar to:

FROM python:3

ENV AIRFLOW_HOME=<arg>

ENV AIRFLOW__CORE__SQL_ALCHEMY_CONN=<arg>

ENV AIRFLOW__CORE__CELERY_RESULT_BACKEND=<arg>

ENV AIRFLOW__CORE__BROKER_URL=<arg>

RUN pip install apache-airflow[postgres, redis]

RUN airflow initdb

RUN airflow worker

RUN airflow webserer -p 8080


3) Build and Push image to Dockerhub (or other repo)
docker build -t myuserid/airflow .
docker push

4) Deploy container to a Kubernetes cluster with a load balancer service of at least 2 replicas
note: this assumes the Kubernetes cluster already exists and is configured to run on AWS
