Welcome
=======

Kubify OS, Version: 9013.0.2
Turn-Key DevOps/MLOps Stack
Rapid Development Platform

Getting Started
===============

Local Install
    A: `pip install kubify`
    B: `conda install kubify`
Local Start Kubernetes Kind Kubify Rapid Testing Cluster `kubify --up`
A: Local Start Entire Enviornment in Multi-Service Kubify Code Edit Mode `kubify --start-all`
    * deploys all Terraform locally to localstack AWS Cloud Services
    * deploys all Serverless Framework to LocalStack AWS Cloud Services
    * deploys all Services to local Kind Cluster using Skaffold for Hot Reloading All Services
B: Local Start a Service and all it's Dependant Services in Multi-Service Kubify Code Edit Mode `kubify --start`
    1. `cd services/[][]`
    2. `kubify --start`
Deploy/Update AWS EKS, GCP GKE & Azure AKS
Stop local Kubernetes Kind Cluster `kubify --down`

Contributing Tools
==================

It's As Simple As `make rapid` To Test All, Version And Push What You Have Committed Versioned

A: CONTRIBUTING.rst
   Includes Efficient Workflows For Contributing To This Repo (And For Any Custom Installs) Enjoy
B: Dev Container VSCode
   Click The Dev Container Button In Your IDE Of Choise (Example: Visual Studio Code's Green Button)
C: GithUb Workspaces
   Most Efficient On-Boarding Use Case (For Installs And Contributing): Click "."" Key in GitHub

Ideolegy
========

Here is the missing tool
AutoDevOps AutoMLOps Turn-Key solution
1 Click To On-Board Developers To Your Infra And Repos
Rapid Test Real Infra and Code Changes At The Same Time
* Deploy the Same Way that you Code
* Itterate Fast when Building Many-to-Many Services
* Rapid Test Your Real Infra As You Build
    * Know Before You Deploy