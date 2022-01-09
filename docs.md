# More Docs
===========


# I cleaned up readme.md and moved noisy sections here:
=====================================================



# Where in Git?


This should be a Top-Level Repo in your git* org. The utopia (repo of repos, clone 1 for everything, including all possible submodule services). Automate all the rest of your org's repos in your fork of this repo.  💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻
1 Repo to Rule Them All (When you On-Board at a Company, You ONLY Need to Clone This 1 Repo and run 1 Command, THAT'S ALL IT TAKES, Top-Level Repo in Your Company) .. Even if you have 1000 Service Repos, 1000 DevOps Repos and 1000 MLOps Repos, Those All Become Git SubModules to This Repo (You Only Need to Clone This 1 Repo and Run 1 Command to On-Board to a Company, Including Automatic Configuration of Your Developer Environment Without The Need for Admin Rights or Access to Sensitive Environments, Ready to Code within Your First 2 Minutes, Easy to Understand, MAXIMUM CODE and SUPER EFFICIENCY for your super hard-working Devs) !!!!


# What advantages does `kubify start` rapid testing framework give ?


 - The Services (in your kubify.yml and in the service depends_on chain) DBs will Start and Run Migrations+Seed (MAKE SURE YOU HAVE SEEDS!!)
 - Dependent Services/DBs/CloudFormationsInKubifyYml/TerraformsInKubifyYml/SLSsInKubifyYml Will Also Start and Listen for Code Changes (AMAZING) !!
 - AWS Resources (in your kubify.yml and in the service depends_on chain) will Deploy to your Local AWS (LocalStack), so you can Rapid Test with Your Entire AWS Cloud + K8s Running on Your Workstation (FULL+RAPID TESTING, ONE OF A KIND, TRULY REVOLUTIONARY, THE MAGIC!!)
 - Now You Can Edit All Services At The Same Time (And They All Hot-Reload, Hot-ReDeploy, Hot-Package)
 - Note: When you stop Code Listening (crtl-c) the Service Stops Running and the DB Deletes Itself (by Design, Forcing the need for SEEDS!!) <-- PLEASE do not forget to add seeds to your DB Migrations ..
 - Pro Tip: You can Enable a DEBUG Port for Breakpoint Configuration
 - Pro Tip: Package Cache Folder in sync (on kubify.yml) so when it Hot Reloads, Service Comes Up Super Fast (Will Not Have To Download Dependencies)
 - Pro Tip: When environment variable ENV is "local" (automatically) then your code should know to run Unit tests (and possibly integration tests) on Boot (This Makes Rapid Testing 10x Better/Funner, TRUST)


# Setup Your Workstation (in more detail)


Option A: Using a Container for Everything:
 - `./kubify up_using_container`  <- BEST OPTION (ready, but it's a brand new feature, just a heads up that I am doing testing to be sure this is stable on each operating system at the moment)
    - NOTE: no admin rights needed ever, as this all runs inside a container (yay!!)
Option B,: Using a Local OS for Everything:
 - `./kubify up`
    - NOTE: admin rights might be required, but i'm 90% done with removing that requirement
       - #TODO: willy: to finish the last 10% of non-sudo code factor and make sure no admin rights (check on new mac, new pc, new debian, new centos and existing of each to be sure, then test every feature, including browser certs automation)


# Setup Your AWS Cloud (in more detail)


1) Create Your KMS Keys (Example: 1 Per Env) and Add Users to Each.
2) Run `dev/aws/deploy-or-update-DEV.sh` (to deploy your clusters if not already exists or/and update/upgrade your clusters config anytime)
 - this manages 4 eks clusters:
     1) kubify-cpu-dev-west: has minimum 1 of t3.micro spot (80% lower cost) instance type, default max nodes is set to 10 (configurable)
     2) kubify-gpu-dev-west: has minimum 1 of t3.micro spot (for core containers, so they don't schedule on gpu nodes) and has minimum 0 (and scales back down to 0) of g4dn.xlarge spot (80% lower cost) instance type, default max nodes is set to 2 (configurable)
         - scales back to 0 after gpu containers finish running
     3) kubify-cpu-dev-east: dr failover cpu cluster (Failover DR automated cluster and HA for Spot Capacity reliability)
     3) kubify-gpu-dev-east: dr failover gpu cluster (Failover DR automated cluster and HA for Spot Capacity reliability)


# What


We need to tap into the true potential of Kubernetes. Let's also deeply automate Kubernetes. Let's do all of our rapid coding/testing (from now on) on a real working full environment (this is where Kubernetes REALLY shines, but no one seems to be using this local rapid testing featureset that I have seen, so I made this SUPER-EPIC-ROCKSTAR-CODER repo to fill that void and to build out a full-blown turn-key DevOps solution). As a developer, I know how hard you work, I know what you run into daily, it's a pattern. Let's build next-gen coding and self-service Auto-DevOps pure-genius patterns together!
Kubify is a DevEx (Developer-First) Kubernetes Turn Key full SDLC Framework (DevOps Solution) that allows you to easily rapid test entire infra locally (the same way as it's deployed), driving amazing quality in services' code commits (with MAXIMUM efficiency) !! 💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻
Please do contribute.. Please provide feedback.. Help me, help you.. We can pull this off if we build a community around this repo.. Expect this repo to stay Open Source forever (so you will get street cred for contributing)..


# Why


For the greater good
To Evolve Rapid Testing
First Class Automated K8s !!
Kubernetes, but 1000x Easier !!
DevOps & MLOps at Scale, Turn Key
Turn Key DevOps MLOps EKS QuickStart
Reduce Confusion in Your Environments 💻
Debug in Real Environment (Revolutionary)
Automated Versioned Deployments (Easy to Patch)
Rapid Coding & Testing (Code Multiple Times Faster)
Turn Key Kubernetes (Skip the Years of K8s Headaches)
Develop Code Faster Than Anyone Else (Faster to Market)
Developers/DevOps/DevSecOps Love Kubify (See For Yourself) 💻
Cost Crushing Your AWS Bill (Lowest Cost EKS DevOps MLOps Solution)
To Finish What Google Started (Make Kubernetes Awesome For Devs/DevOps)
First Class Multi-Region Redundancy (Fully Automated Failover Services/DBs)
On-Boarding takes 1 Minute (Instead of 1 Month of workstation/access issues) 💻
Automated/Reliable FAST Scaling Out/In CPU/GPU Spot in East/West (Next-Gen EKS HA ASGs)
Rapid Software Development of Multiple Services at the Same Time (Happy Hard-Working Developers)
Quality Commits (Every Commit is Tested in FULL locally, No More Bugs in Prod, No More Stepping On Toes)
DevEx Consistency (Happy Devs, Rapid OnBoarding, No More Waiting, Self Service, Know Before You Commit/Deploy, 1 Command Total) !!
The World NEEDS a Best-Practices Turn Key DevOps Solutions, So That DevOps can focus on DevSecOps (SECURITY OVER EVERYTHING), rather than Focusing on Re-Inventing the Wheel Every Time ..


# Contribute, Pretty Please


YOUR TASK: TELL EVERYONE YOU KNOW ABOUT KUBIFY
Let's build Auto-DevOps Together (Please Consider Contributing) !!
Still need motivation?: The Lead Developer and Creator, Willy Guggenheim, works next to 9 calm tiny chihuahuas and LOVES SpeedMetal, MetalCore, LatinoPop and especially HipHop (music is LIFE) !!
Still need motivation? THAT IS EASY TO FIX: https://www.youtube.com/watch?v=7m0n8h8b89M (so now you are motivated to contribute forsure) !!
STILL NEED MOTIVATION??? THAT IS EVEN EASIER TO FIX: https://open.spotify.com/user/1245085779?si=7b16f3916e08407c !!


# Developer, Just Like You


Willy Guggenheim, Las Vegas, 20+ Years Coding Experience, Loves MLOps, DevOps and especially DevSecOps ..
Willy@GugCorp.com <--- HMU if you want to pair on this (please have at least 10+ years experience in coding before reaching out for pairing session requests) ..
Pure-bred Coder, 20 Years Experience, Hardcore DevOps Engineer and my passion is coding
Creds: 60 Coding/Security/Cloud Certifications (World Record), WGU Software Grad, UCLA Coding Tutor, Principal Software Engineer, Principal MLOps Engineer, Principal DevOps Engineer, Principal DevSecOps Engineer, Senior Data Scientist, Principal Cloud Security Architect, Principal Endpoint Security Software Engineer, AWS Solutions Architect Teacher, Kubernetes Fan #1, EKS Potential-Knower, Human and AWS Cloud Extremist, ..
Huge thank you to my beautiful genius amazing wife Allana Guggenheim and to my 9 chihuahuas for all the inspiration .. 