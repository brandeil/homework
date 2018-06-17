#!/bin/bash
sudo su
apt-get update
apt-get install python-pip -y
export AIRFLOW_HOME=/home/ubuntu/airflow
export AIRFLOW__CORE__SQL_ALCHEMY_CONN=$1
pip install apache-airflow[postgres]
# initialize the database
airflow initdb
# start the web server, default port is 8080
airflow webserver -p 8080

#sql_alchemy_conn=
#base_url=
#web_server_host
#web_server_port
#broker_url
#celery_result_backend