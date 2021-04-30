#feature #1: APM with ISTIO
#feature #2: Auto-Configure IDE Debugger on "kubify debug"  
#more features that come to mind:
- (similar to Ubuntu/Debian Kind implementation): change Mac to also use Kind (instead of the docker desktop K8s)
  - after much performance testing I found that docker desktop is a lot slower than Kind (and uses more CPU than Kind, so important)
- M1 compatibility
- permissions between services automated in kubify.yaml
- automate kafka
- automate localstack
- native windows option (other than wsl2) with install_windows.yaml
- migrate to using docker cmd for all cli commands (so it runs anywhere smoothly, less porting)
	- use kind, start with linux migration
- fix WSL2 windows
  - also automate this current pre-req flow: 
      - on WSL2: you must first (before running kubify up for the first time on Windows): enable WSL1, install WSL2, upgrade to WSL2, Install Ubuntu for Windows from Microsoft, open Ubuntu for Windows, make sure it's upgraded to WSL2, make sure install Docker Desktop (and that will install docker into that WSL2 Debian distro mapped to host Docker Desktop and host Kubernetes on the Windows side).. 
- add kubemq automation (backed by interface to sqs or kubemq container, based on deployed and local env automation)
- build various example 'hello kubify world' services in various languages, since this is turn key
  - add those to tooling as well
- add istio apm (FREE APM!!!!) feature to example services
- add istio logs or/and greylog option (FREE LOGS and beautilful LOGS UI!!!!)
- make sure CICD linux is stable, add example entrypoint files for cicd systems to run the cicd scripts
- auto configure vscode eclipse and pycharm move versions to one file
- ensure virtual env everywhere
- brew to use virtualenv
- python to use virtualenv (with full automation and coverage)
- serial number filtering 
- waf
- istio with APM by default!!
- service mesh
- UI
- Multi-Cloud (Checkmark and BAM you are backed by another cloud)
	- MCDS (coined fun phrase by Kubify OS): Multi-Cloud Distributed Services !!!! Super Awesomeness !!!!!! Should be as easy as a checkmark (bool) to enable multiple cloud providers and Kubify would automatically know what to do (focus on your code, you amazing coder, because we love you)..
- DR by default 
- convertor from ecs, heroku, ..
- Versioning to one file paramerized everywhere else. 
- Code listening on remote cluster
- https://kubernetes.io/blog/2021/03/09/the-evolution-of-kubernetes-dashboard/
- Kubeproxy with Hybrid Development rapid testing (develop a service locally and it to be part of a remote k8s cluster)
- CICD should run e2e full integration test daily on each important branch with pagerduty notifications on broken anything
- Add one of these to each cli function (or similar)
```
  if [ "$KUBIFY_DEBUG" != "0" ]; then
    echo "DEBUG: RUNNING THIS CLI FUNCTION: "
  fi
```
- Run multiple environments on your workstation (think async local cicd edge computing future we will live in)..
- Add a super cool progress bar for "kubify up" (when running outside of debug mode): https://laptrinhx.com/use-images-as-progress-bars-in-the-terminal-86135668/
- Merge the services' config and secrets folders into the kubify.yaml (for each example service and tooling usage)

Upgrade bash for mac
brew install bash
Add extension bash debug
Select Debug -> Add Configuration to add custom debug configuration (drop-down, path-input, etc...)
Select Debug -> Start Debugging (F5) to start debugging