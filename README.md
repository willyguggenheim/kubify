![TURN_KEY_DEVOPS_RAPID_TESTER](./docs/img/README_md_imgs/kubify-arch.drawio.png)

# Awesome !!
 
Well hello there..

Ready to Simulate AWS Cloud Locally??


# By Why ?

What if you can test the entire cloud on your laptop?! Yes, the entire cloud, EXACTLY how it's deployed into AWS!!

Alright, so what if LocalStackAWS, Docker-Compose, Serverless-Framework, Terraform, CloudFormation, Kubernetes, EKS, Skaffold and Skater Hot Reloader had a baby? This is what it would look like. 1 Tool To Rule Them All, 1 Command To Test Anything In Your Org !!

So you can code at lightning speed. So your commits are already tested in full on your machine. So you can feel confident about your code before you push it within the first 5 minutes of working at a company !!

It's impossible right? Terraform and Docker-Compose will always be seperate tools?! NOPE. Clone This Repo if you want to live in the future !!


# Future State?

Fork Terraform and build this into it.


# What do I need?

Mac, Linux, Windows or any Docker

AWS Account(s) and Access to AWS KMS, EKS and EC2 (or for the CICD to have access)


# Dependencies For Runtime?
 
Just Docker !!

NOTE: Admin Rights are Not Required (from v9000.0.0+)


# What Are All These Folders About?

- dev/aws/ = eks 4-cluster ha+failover cpu+gpu deployers (deploys the 4 clusters: cpu+gpu in west & cpu+gpu in east for dr and ha)
- dev/env/ = what versions of services are deployed to what aws environment (including eks clusters, sls, cf and terraform kubify)
- dev/svc/[*] = private services (folders and/or git submodule folders for backend eks services)
- dev/pub/[*] = public services (folders and/or git submodule folders for frontend eks services)
- src/ = the magic

# Concept

- dev/svc/[*]/kubify.yml file = Docker-Compose, Serverless-Framework, Terraform, CloudFormation, all in 1 File and easy to Read (Accepts ShortHand Kubify SelfService Syntax and Even Real Full TF/CF/SLS/Manifest Syntax as Well) !!
- `kubify start` = Ansible reads kubify.yml depends_on Service Chain (all Dependant Services Start in Order), Then It Automatically Creates CloudFormation Templates, Automatically Creates Terraform, ... and it Automatically Deploys Everything On Your Laptop (The SAME Way it Deploys To The Cloud, All AWS Resources On Your Laptop, Entire Cloud), Then All Of Those Services Listen For Code Changes (So You Can Edit Them All Locally At The Same Time) !!


# Magic, Pure Magic!
 

For more information on these topics, please review all the *.md files (more.md, docs.md and todo.md) ....

This engine deploys your AWS resources for you (self service idioligy), both to the cloud AND to your workstation (you simulate the entire cloud on your laptop and rapid test on it) ....

Streamlined Self Service for Developers (Auto DevOps)
 
1 Yaml File Per Service (Easy to Migrate/Maintain)
 
1 Yaml File Per Environment (Easy to Roll Back/Debug/Patch)
 
Dependant Services Automatically Start Listen for Code Changes (Automatically)


 
# Setup Your AWS Cloud
 
 
1) Create Your KMS Keys (Example: 1 Per Env) and Add Users to Each.
 
2) Run `dev/aws/deploy-or-update-DEV.sh` (Deploys and/or Updates Configs on your dev EKS Clusters).


# Cleanup Cloud (For Testing Beta)

```
eksctl delete cluster --name "kubify-cpu-dev-west" --region us-west-2 &
eksctl delete cluster --name "kubify-gpu-dev-west" --region us-west-2 &
eksctl delete cluster --name "kubify-cpu-dev-east" --region us-east-1 &
eksctl delete cluster --name "kubify-gpu-dev-east" --region us-east-1 &
wait
```


# Summary, Install/Reset Workstation


1) Install Kubify:

    Two Options:

    A) Full Install (admin rights required during install): `./kubify up`

    B) Install Inside Container (no admin rights required): `./kubify up_container`

2) Uninstall Kubify:

    Two Steps:

    A) Delete The Kind-Kind Container: `kind delete cluster`

    B) Delete RapidT Kubify Container: `docker-compose stop && docker-compose rm` 



# Thank You

AutoPilot For Devs and DevOps ..

![FUTUREOFDEVOPS9000](./docs/img/README_md_imgs/the-future.gif)



# Hashtags, More Hashtags
 
 
💻💻💻💻💻💻💻💻💻💻💻💻
 
#AUTOPILOTFORDEVOPS
 
#STAYINSPIRATIONAL
 
#FREESOFTWARE
 
#THEFUTURE
 
#DEVLOVE
 
#DEVEX
 
💻