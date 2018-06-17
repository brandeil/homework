#!/bin/bash
export AIRFLOW_HOME=/home/ubuntu/airflow
export AIRFLOW__CORE__SQL_ALCHEMY_CONN="sqlite:////home/ubuntu/airflow/airflow.db"
pip install apache-airflow[postgres]
airflow initdb
airflow webserver -p 8080
