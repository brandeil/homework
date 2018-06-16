#!/bin/bash

# connect to AWS CLI to create the stack

# remote into the EC2 and use sed to update ~/airflow/airflow.cfg to values from AWS resources
#sql_alchemy_conn=
#base_url=
#web_server_host
#web_server_port
#broker_url
#celery_result_backend



# initialize the database
airflow initdb

# start the web server, default port is 8080
airflow webserver -p 8080

