![TURN_KEY_DEVOPS_RAPID_TESTER](./lib/docs/img/README_md_imgs/kubify-arch.drawio.png)

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
- lib/ = the magic

# Concept

- dev/svc/[*]/kubify.yml file = Docker-Compose, Serverless-Framework, Terraform, CloudFormation, all in 1 File and easy to Read (Accepts ShortHand Kubify SelfService Syntax and Even Real Full TF/CF/SLS/Manifest Syntax as Well) !!
- `kubify start` = Ansible reads kubify.yml depends_on Service Chain (all Dependant Services Start in Order), Then It Automatically Creates CloudFormation Templates, Automatically Creates Terraform, ... and it Automatically Deploys Everything On Your Laptop (The SAME Way it Deploys To The Cloud, All AWS Resources On Your Laptop, Entire Cloud), Then All Of Those Services Listen For Code Changes (So You Can Edit Them All Locally At The Same Time) !!


# Magic, Pure Magic!
 

For more information on these topics, please review all the *.md files (more.md, docs.md and todo.md) ....

Your entire AWS Cloud, deployed exactly the same way, while coding on the containers it deploys, while those containers hot reload and automatically run unit tests, while giving you a debugger port for your IDE, while knowing that. This is amazing ..

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

 
# Setup Your Workstation

Option A: Using a Container for Everything: `./kubify up_using_container`

Option B: Using a Local OS for Everything: `./kubify up`



# Rapid Testing Services
 
Theme: One Testing Command (Across an Entire Org) to Rule Them All!!
 
- Start Rapid Testing: `cd dev/svc/example-django-simple-svc && ../../kubify start`
 
- Edit a Secret: `../../kubify secrets edit dev`
 
 

# Cool, Now What
 

1) Rapid Test Your Services Until They Work (Make Code Changes to Multiple Services and Watch them Hot Reload, Unit Test, ..) !!
 
2) Contribute to this repository (it will remain open source for the long run) ..
 
This is FREE (and Open Source) turn key DevOps revolutionary software that I worked VERY hard on. If you use Kubify, make sure to donate (if you use this in prod, then MAKE SURE AND DONATE PLEASE): [![](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate?business=MSRFJHSGCKGCG&item_name=Kubify&currency_code=USD)

That's it! Thank you for coding and enjoy ..

AutoPilot For Devs and DevOps ..

![FUTUREOFDEVOPS9000](./lib/docs/img/README_md_imgs/the-future.gif)

Brought To You By: DJ EPIC CODER (Willy Guggenheim): 
Follow Me On Spotify: https://open.spotify.com/user/1245085779?si=7b16f3916e08407
Latest List (to Celebr8 v9000.0.1 Pre-Release): https://open.spotify.com/playlist/7f2JYY3RampGTtB0SKXcW8?si=a9d1b199fb284ade

# Hashtags, More Hashtags
 
 
💻💻💻💻💻💻💻💻💻💻💻💻
 
#AUTOPILOTFORDEVOPS
 
#STAYINSPIRATIONAL
 
#FREESOFTWARE
 
#THEFUTURE
 
#DEVLOVE
 
#DEVEX
 
💻