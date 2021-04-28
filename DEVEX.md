The maturity of DevOps/DevEx/DevSecOps is like a self driving car,
There are really 5 layers of maturity for DevOps/DevEx/DevSecOps:  


Summary of Levels:


 Levels: 

Level 1:
	- Lift and Shift
	- Snapshotting
	- Manual Release Process
	- IDE Deployment Plugins
	- Manually Created Resources+Config in Cloud 	- Manually Created Resources+Config on Workstation 	- Manual Schema Changes
	- No Docs
	- Manual QA Process
 Level 2: 	- Docs on Level 1 Process
	- Terraform, CF, Jinja, ARM Automated Cloud Resources (but just keeping the Cloud in mind)
		- Since DevEx patterns (local automation, self service) were not used and only Cloud was kept in mind (since there was a full focus on customers): it is  Developed in a way that puts all the day-to-day heavier support burden on DevOps, resulting in a very busy DevOps Support Board, blocking developers and making hard working devs often deeply frustrated/slow/confused. An “over the fence” approach ..
	- GitFlow with Trunk-based Release Process (dev->dev, master->staging, ..) 		- The problem with just relying on GitFlow alone (to make devs efficient and happy) is that in this world: Developers keep stepping on each others toes, are not rapid testing locally and have to wait every time for CICD (what if they want to deploy 100 times in that day and rapid test each time?!) 	- Versioning is used for releases, but manual process 	- Manual QA Process, but now it’s documented (even if manual) 

Level 3:
	- Docs are awesome, but they are very long and sometimes unclear
	- Cloud deployments are perfectly automated
	- Unit Tests in place
	- Developers still stepping on each others toes in the environments
	- No DR
	- Worried about doing a Terraform destroy/apply, as backup/restore not automated 
	- QA full regression test automation (that tests the all services in the infra in full everytime before each rapid release in CICD) is being built

Level 4:
	- MLops Automated (I am really impressed with how MLops has been automated lately, NICE !!)
	- Kubify (solves all the above and more !!)

Level 5:	
	- Kubify deeper involvement (automate all the things, self service, focus on devs efficiency and happiness levels)
	- Developers can easily work on any service in the entire company, know it’s working perfectly (in full, with all infra) rapidly locally (same way as it runs in the cloud) 	- Developers love the 
	- Security vastly improved
	- On-Boarding (new devs) time is down from months to minutes !!
	- Kubify to have APM, Logging, ….. as part of each stack 	- All major services we use (DBs, Queues, …) are Kubernetes native and super easy to enable (per service) in the kubify.yaml (1 file per service) 	- We have succeeded with sticking to DevEx patterns, such as: 
		- 1 easy to read yaml file per service 		- 1 easy to read yaml file per environment 		- the entire infra (at the same time) runs perfectly/automated the same way as in the cloud, for when we rapid test locally  	- QA full regression test automation is complete, is fully automated right in to the Kubify tool, is also part of git pre-commit hook (all commits will be clean going forward) 


___________________________


Another way of looking at that is:


1 = lift and shift, spinning up snapshots, all manual
1.5 = ide deployment plugins, schemas not yet automated,  manually created resources in cloud and especially manually created testing infra on workstation
2 = terraform, gitflow trunk branch-based release cicd, deployments somewhat automated, versioning in place per repo and not fully implemented, qa still a  major pain before each release, getting workstation configured still a pain, developers still confused, on-boarding very hard
2.5 = not releasing fast yet, but still addressing the lambda local testing automations, local testing (with minimal deps), docker-compose automations, alembic db migration automation, serverless, serverless framework, terraform, security scanner tools, .. 
3 = almost perfect automation, more qa gitflow effort, but no deep regression tests yet that are supposed to be automatically testing/blocking deployments (qa still a very much manual process), developers still would still have local testing headaches, some processes are still manual, still some confusion, developers stepping on each others toes in deployed envs
3.5 = automate regression tests by trunk branch ran daily accross entire infra and has alerting in cicd giflow automation (so be able to confidently release fast), the on-boarding burden is down from months to weeks. Kubify automation in flight, security, compatibility and rapid testing features being the focus .. 
4.0 = Kubify, CICD Perfect, Docs Clear, Everyone is Happy, Developers day is streamlined and everyone knows how to work on any service confidently, everyone works on the real full infra when they rapid test locally, GitFlow perfected and documented, db migrations automated and have full coverage .. can also include MLOps schedulers...
4.5 = Developer on Day 1, within the first 5 minutes of working can get the entire infrastructure running on their laptop securely/consistently, docs self-sufficent, developers have a strong level of self service (example: if I want a postgres db, I just put a "postgres" line in my service's only devops file named kubify.yaml), more security automated/hardened (since kubify has patterns that automate large parts of security) automations, automate qa as much as possible end to end (between real full-infra local rapid testing and a full qa regression test, we can confidently release new features FAST), docs perfected and devs all agree they are clear/perfect/ready. All the urgent and important feature requests of Kubify are done, tested and accepted. Regression tests use Kubify, so they test in a real full environment. 1 file per service, 1 file per environment. Deployed environment down/up backs up the DBs (KubeDB) and queues (KubeMQ), restores the real data on up.
5.0 = Fully Automated, Super Clear, Automated IDE configuration, Automated On-Boarding of Dev Workstations, Developers LOVE the fully automated platform (and they know it well, since docs are super clear and automated)! When we are the point where we are mostly focused on coding new feature requests (from security team and devs feedback) for Kubify. Kubify our main tooling for almost everything. The on-boarding burden is down from months to minutes. Rapid testing being awesome. Kubify is perfect and everyone is super happy (as much as possible of a developers day is automated, so the goal is less support tickets to devops). 

This is very similar to the 5 levels of say a self driving car..this is full automation autopilot of devops, so devops can focus on quality, features, performance, mlops pattern hardened, automated, easy to use and documented, kubify feature requests and especially building stronger automated pattern-based SECURITY (focusing on increasing the security automations using k8s automation patterns in Kubify). 

___________________________


Another way of looking at that is:


The maturity of DevOps/DevEx/DevSecOps is like a self driving car,
There are 5 layers of DevOps/DevEx/DevSecOps. Levels:
1 = lift and shift
1.5 = manual
2 = terraform with flat services
2.5 = schema automation, gitflow and serverless framework
3 = qa automation and cicd automations
3.5 = mocks and infra refactors
4.0 = devex
4.5 = proven awesome devex and security focus
5.0 = kubify and making developers super efficient/happy by allowing them to build with quality (since tested with entire infra locally the same way as it runs in the cloud) and with self-service (1 yaml per env, 1 yaml per service), allowing a deeper focus on security  


___________________________


So DevEx is like a self driving car and Kubify will get us there FAST !!
I am SUPER excited to go on this journey to 5.0 with Kubify !!
DevEx is amazing..

___________________________

Thank you,
Willy Guggenheim
Lead DevEx Automation Engineer
58 Coding/Security/Clouds Certifications
WGU Dual Major in Network and Software Engineering
willy@gugcorp.com
