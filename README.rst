Welcome
=======

Kubify OS, Version: 9015.0.1

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

Stop local Kubernetes Kind Cluster `kubify --down`


Contributing Command
====================


It's As Simple As `git commit [] && make rapid` To Test All, Version And Push



Developer Context
=================


To (Optionally) Start 100% In A Container, DevContainer or Docker-Compose, or Similar ..

To Install Directly On Mac/Linux/Windows/WSL/WSL2, Use Ansible Roles In `kubify/ops/ansible`

To Install The Example Multi-Cloud MLOps DevOps Stack for Deploying with CICD to 

AWS EKS, GCP GKE & Azure AKS `kubify/ops/terraform` and one Way to Deploy Those is With `make clouds`

CloudFormation And Serverless Jinja Templates are in the ansible Folder for `kubify.yml` shorthand syntax

Additional Workflows:

A: CONTRIBUTING.rst
   * Includes Efficient Workflows For Contributing To This Repo (And For Any Custom Installs) Enjoy
B: Dev Container VSCode
   * Click The Dev Container Button In Your IDE Of Choise (Example: Visual Studio Code's Green Button)
C: GithUb Workspaces
   * Super Efficient On-Boarding Use Case (For Installs And Contributing): Click "."" Key in GitHub


Ideolegy
========


A Proven PROOF OF CONCEPT (Python Port IN PROGRESS) To Show The Idea And To Productionize It Together, 

Code Delivery Platform to Solve Regression Testing Early in the Development Process, Without The Wait,

A Fun Project I am Building To Prove An Interesting Next Gen Self Service Platform For Devs, DevOps and MLOps, to All Work On The Same Code Base, 

1. In The Kubify Platform, DevOps/MLOps/Devs/DataScientists/Researchers/Engineers Write Code Terraform/SLS/CF/ArgoCD/Services/ML At The Same Time, The Same Way, And Test The Same Way, As 1 Big Team (Same Codebase)
    * 1 Kubify Yaml in each `./services/[group][name]` Folder `kubify.yml` (Rapid Test in Local/DevContainer/CodeSpaces/NotebookServers/VSCode All Your Terraform/SLS/CF/ArgoCD/Services/ML/AWS and The Same Time)
    * 1 Environment Yaml, Each Environment Gets 1 Auto-Versioned Environment File (Easy to Rollback Multiple Services and Easy to UAT/Clone Prod Without Needing Any Access To The Data To Debug Anything, Solve/Debug Fast)
2. Developers Leverage DevOps/MLOps CodeBase Day-In-Day-Out To Test and Contribute (If It Works On My Laptop, It Works in Prod, That's What Makes This Different, Join-At-The-Hip Your DevOps/MLOps Devs to All of Your Devs)
3. Developers Are Now More Effecienct (1 Click/Command And You Are On-Boarded To Your Code Working Environment, With a Full Simulation of The Cloud Locally, With All Dependant Services Listening For Code Changes Hot Reloading)

Join-At-The-Hip Your DevOps/MLOps Hard Working Software Developers with the rest of Your Hard Working Software Developers With This Idea/Ideolegy

AutoDevOps AutoMLOps Turn-Key Solution for Developers, 1 Click/Command To On-Board Developers To Your Infra And Repos, Get Your Devs Up and Running With A Click

This Marries Your DevOps/MLOps Teams to Your Developer Teams For Maximum Efficiency In Itterating

Rapid Test Real Infra and Code Changes At The Same Time
* Deploy the Same Way that you Code, With The Real Infra Code
* Itterate Fast when Building Many-to-Many Services, Really Fast
* Rapid Test Your Real Infra As You Code, Test and Itterate
* Know How It Will Function In The Cloud, Before You Push

Happy Coding