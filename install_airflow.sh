#!/bin/bash
sudo apt-get update
sudo apt-get install python-pip -y
export AIRFLOW_HOME=/home/ubuntu/airflow
pip install apache-airflow
/home/ubuntu/.local/bin/airflow initdb
/home/ubuntu/.local/bin/airflow webserver -p 8080