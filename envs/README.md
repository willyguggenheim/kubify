# Environments

This controls what version (of each service that you want to deploy to the cluster) deployed (and to what cluster it gets deployed to).

The dev.yaml file represents local `kubify run` and `kubify run-all` (`kubify start` does not use this folder, as `start` is for rapid testing on latest code) ..

The dev.yaml file also represents the EKS dev environment. The idioligy is like so: You can test the exact dev cluster locally before you commit (so you already know dev will perform, without stepping on any toes, to produce absolutely revolutionary rapid testing idioligy for quality code) ..

To add more environment (such as prod), simply add yaml file (example: prod.yaml, example: willy.yaml, ..)

To remove an environment: eksctl command (see readme.md) 
    #TODO: Make it so when you delete a file, you get a regular alter of an orphan Kubify stack (maybe?)
    #TODO: When you delete a file (that is not prod.yaml, prod.yml, production.yaml, production.yml, that it deletes the cluster automatically in CICD .. good idea?)