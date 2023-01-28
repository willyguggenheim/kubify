welcome
=======

kubify os, version: 9019.0.0

turn-key devops/mlops stack

rapid development platform


getting started
~~~~~~~~~~~~~~~

install
    
    local install

    a: `pip install kubify`

    b: `conda install kubify`

    container

    a: `docker run -it --rm willy0912/kubify:main`

    b: devcontainer button in your favorite ide

local start kubernetes kind kubify rapid testing cluster ``kubify --up``

a: start all services and infra locally ``kubify --start-all``
    * deploys all terraform locally to localstack aws cloud services
    * deploys all serverless framework to localstack aws cloud services


b: listen for code changes on service ``kubify --start`` 
    1. ``cd services/[][]``
    2. ``kubify --start``
    * deploys any (if not already deployed) dependant services before it starts automatically
    * deploys service with hot reloading (default) so you can rapid itterate many services 
      and infra at once locally (and know it will work the same way in dev/uat/prod/* 
      eks/eks-a/gke/anthos/aks/rks/k8s/openshift/ocp/kind)
        * to code even faster, enable hot reloading in your ``kubify.yml:sync``
            * for example https://github.com/willyguggenheim/kubify/blob/main/services/internal-facing/example-csharp-svc/kubify.yml#L9

stop local kubernetes kind cluster ``kubify --down`` 

think docker-compose, but for kubernetes, the cloud on your laptop, while you code in it

and when you push to your named branch environment, cicd auto-versions and deploys

https://kubify-os.readthedocs.io/en/latest/index.html

happy coding and enjoy