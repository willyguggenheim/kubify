![TURN_KEY_DEVOPS_RAPID_TESTER](./docs/img/README_md_imgs/kubify-arch.drawio.png)

![HOWDY_DO_PARTNER_PROGRAM](./docs/img/README_md_imgs/AWS-Partner.jpeg)

# Welcome

Well hello there! Welcome to Kubify. The Turn-Key DevOps OS Stack.

The world needs a fully Open Source and FREE DevOps Stack. Devs Approved.

It's time to make your Developers happy.


# Awesome !!

Code faster than your Competition. 

Fully Automated. First Class DevEx. Developers-First. Happy Devs. Fixes Spot. No more K8s pains.

You need your own environment, you need to test in real environment, you need to modify multiple services at the same time (without waiting for builds), you need to know your commit works before pushing it and you need the entire cloud on your laptop to do so..


# By Why ?
 
Because Docker-Compose and Terraform are 2 different tools (so I fixed it).
 

# Future State?
 
Fork Terraform and build Docker-Compose, LocalStack & 🛹 Skater Hot Reloader into it.
 
 
# What do I need?
 
Mac, Linux, Windows or any Docker and AWS.
 
 
# Dependencies For Runtime?

Just Docker (no admin rights required) !!

NOTE: Docker Automatically Installs (if not already installed) ..
 

# Start Cloud
 
1) Create kms key(s) alias named like kubify_secrets_[env] (for each env)

2) `./kubify deploy_cloud dev`
 

# Stop Cloud

`./kubify delete_clouds_testing`
 

# Start Debugging Workflow
 
A) To install/run on your OS directly (brew): `./kubify up`
 
or
 
B) To install/run in a container (no admin rights): `./kubify up_container`


# Rapid Test Workflow

```
cd dev/svc/example-node-complex-svc
../../../kubify_verbose start
# open another terminal (because you need to work on another dependant service at the same time)
cd dev/svc/example-flask-svc
../../../kubify_verbose start
# make changes to both service's app folders (or any files/folders enabled in "sync" in kubify.yml)
```


# Environment Isolation

Security Minute: You should not give prod access to anyone. How?
```
cd dev/svc/example-node-complex-svc
ENV=prod ./kubify start
# hot patch services locally (and with the full real environment) without access to data!!
```


# Stop Debugging Workflow

`./kubify down`


# Pro Tips

1) Your services (that have databases defined in kubify.yml) need to have Migrations/Seeds..

2) Please Contribute to Open Source!!


![FUTUREOFDEVOPS9000](./docs/img/README_md_imgs/the-future.gif)

Your own REAL FULL environment (local & cloud). Entire AWS Cloud on Your Workstation!!

Easy Cloud Env, Easy Patching, Easy Version Rollback and Quality Commits, FAST!!

The Future, NOW. Developer's Dreams are Coming True Here..

```
Thank you for contributing to open source software!
Thank you for your interest in Kubify!
Willy Guggenheim
Guggenheim Inc.
```
 
# Hashtags, More Hashtags

💻💻💻💻💻💻💻💻💻💻💻💻

#AUTOPILOTFORDEVOPS

#STAYINSPIRATIONAL

#FREESOFTWARE

#THEFUTURE

#DEVLOVE

#DEVEX

💻💻
 
🛹
 

