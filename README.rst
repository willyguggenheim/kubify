Welcome
=======

Kubify OS, Version: 9013.0.2
Turn-Key DevOps/MLOps Stack
Rapid Development Platform

Getting Started
===============

Install
    A: `pip install kubify`
    B: `conda install kubify`
Start local kubernetes kind cluster `kubify --up`
A: Start entire enviornment in multi-service code edit mode `kubify --start-all`
    * deploys all terraform locally to localstack aws cloud services
    * deploys all serverless framework to localstack aws cloud services
    * deploys all services to local kind cluster using skaffold for hot reloading all services
B: Start a service and all it's dependant services in multi-service code edit mode `kubify --start`
    1. `cd services/[][]`
    2. `kubify --start`
Stop local kubernetes kind cluster `kubify --down`

See CONTRIBUTING.rst optional dev container

Ideolegy
========

Here is the missing tool
AutoDevOps AutoMLOps Turn-Key solution
* Deploy the Same Way that you Code
* Itterate Fast when Building Many-to-Many Services
* Rapid Test Your Real Infra As You Build
    * Know Before You Deploy