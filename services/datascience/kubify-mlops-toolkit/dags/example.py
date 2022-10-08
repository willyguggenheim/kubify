from datetime import datetime
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator


def print_hello_kubify():
    return "Hello Kubify Airflow DAG!"


dag = DAG(
    "hello_kubify_dag",
    description="Hello World Kubify Airflow DAG",
    schedule_interval="0 12 * * *",
    start_date=datetime(2017, 3, 20),
    catchup=False,
)

hello_operator = PythonOperator(
    task_id="hello_kubify_task", python_callable=print_hello_kubify, dag=dag
)

hello_operator
