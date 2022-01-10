# Awesome !!
 
Well hello there again.
 
 
# Current Kubify Sprint (IN PROGRESS)
 
1) STORY_COMPLETED: windows: 5x faster, no more WSL, way more efficient now (closer to Mac/Linux performance, but Windows does not have a Linux-native kernel, so Docker on Windows will always be slower than Linux/Mac)
   - *EARTH TO MICROSOFT*: When is M$ going to create a version of Windows that runs directly on a major Linux kernel??? That's the only way to fix Windows..
   - but yes, it runs a lot faster on Windows now, lol
2) STORY_COMPLETED: doc: deleted all the docs (just like that, why not) and wrote 2 new ones (readme and todo)
3) STORY_IN_PROGRESS: refactor: ground up, heavy, breaking change
5) STORY_IN_PROGRESS: bootstrapper: 1 step to get started, down from 10 steps
6) STORY_IN_PROGRESS: bootstrapper: `kubify up` is now 10-100x faster and NO MORE ADMIN RIGHTS NEEDED ON ANY OS !!
7) STORY_COMPLETED: getting-started: made it easier to fork by separating package (lib folder) code from services (dev folder) code
8) STORY_TODO: multi-region: services, fully automated
9) STORY_COMPLETED: bootstrapper: eks, fully automated
10) STORY_COMPLETED: security: workstation bootstrapper now has 10x the security on every OS, as we only need/use docker going forward
11) STORY_COMPLETED: kubify.yml: deploy cloudformation things (automated, wrapped nicely)
12) STORY_COMPLETED: kubify.yml: deploy terraform things (automated, wrapped nicely)
13) STORY_COMPLETED: kubify.yml: rapid test lambdas (same command) `kubify start` (and it even works with mix of service and multiple lambas)
14) STORY_COMPLETED: kubify.yml: deploy serverless framework things (automated, wrapped nicely)
15) STORY_COMPLETED: bug: fixes
16) STORY_COMPLETED: cicd: versioning bump2version automation
17) STORY_COMPLETED: coding: improved my ide config for max kubify coding efficiency (rapid testing the rapid tester)
18) STORY_TODO: waf: aws best practices waf solutions, move public setter to kubify.yml, add email alert
19) STORY_TODO: github: security: https://github.com/willyguggenheim/kubify/new/master?dependabot_template=1&filename=.github%2Fdependabot.yml configure dependabot.yml
20) STORY_IN_PROGRESS: cicd, round 1
21) STORY_IN_PROGRESS: dr: automate This DR Failover Solution https://aws.amazon.com/blogs/containers/operating-a-multi-regional-stateless-application-using-amazon-eks/
22) STORY_IN_PROGRESS: dr: automate KubeDB Multi-Region
 
 
# Q1 2022 Upcoming Features (UP NEXT)

0) Upgrade All Dependancies & Deep Testing
0) Chrome & PostMan in Container (UI to Pop Up on Workstation, But Running in Container): https://medium.com/dot-debug/running-chrome-in-a-docker-container-a55e7f4da4a8
1) Make an explainer video
2) Make contributor training videos
3) bootstrapper: on-prem cluster creator v1
4) cicd: jenkins
5) cicd: codecommit
6) multi-region: deep testing of new multi-region automations for global load balancer, cf, deployers, databases and services
7) beta: harden all beta features
8) security: versioning checks, releasing, docker sha256 checking, artifacts sha256 checking and cicd security checks
9) gpu: gpu automation (scale on 1-gpu-1-container) and should be the default
10) gpu: vgpu option (scale on %, for applications that want to share gpu between containers)
11) monitoring: automate low/high priority alarms (high priority alarm if prod and if high priority threshold/type), require pagerduty account (store in SecureString automatically, use inside the eks bootstrapper)
11) monitoring: automate cloudwatch dashboard (with logs, telemetry, KMS keys usage logs and alarm history from SNS->PD logger&telem)
12) automate: kms key provisioning (if not exist), with logging enabled
13) dbs: make sure kubedb-kubedb-autoscaler is implemented and working (stress test database, make sure it scales out/in on each database type offered by kubedb, check both regions)
 
# Random Ideas (AFTER ABOVE SECTION)
 
1) tool/migrate: cloudformation to kubify.yml convertor v1
2) tool/migrate: terraform to kubify.yml convertor v1
3) av: clamwin on containers
 
 
# Wild Ideas (AFTER ABOVE SECTION)
 
1) Integrate into AWS Cloud9 (do all your coding from the AWS Console with 0 latency)
 
 
# Tech Debt (AFTER ABOVE SECTION)
 
1) Handle TODO flags
2) Another once-over on README.md
 
 
# Yo (YO)
 
1) Yo
2) Yo
3) Yo
 

