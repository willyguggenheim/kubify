badges
~~~~~~

.. |Docker| image:: https://github.com/willyguggenheim/kubify/actions/workflows/docker-image.yml/badge.svg?branch=main
   :target: https://github.com/willyguggenheim/kubify/actions/workflows/docker-image.yml
.. |PyPi| image:: https://img.shields.io/pypi/v/kubify.svg
   :target: https://pypi.python.org/pypi/kubify
.. |PyUp| image:: https://pyup.io/repos/github/willyguggenheim/kubify/shield.svg
   :target: https://pyup.io/repos/github/willyguggenheim/kubify/
.. |Docs| image:: https://readthedocs.org/projects/kubify/badge/?version=latest
   :target: hhttps://kubify.readthedocs.io/en/latest/?version=latest

.. figure:: ./docs/img/README_md_imgs/kubify-arch.drawio.png
   :alt: TURN_KEY_DEVOPS_RAPID_TESTER

aws partner network
~~~~~~~~~~~~~~~~~~~

.. figure:: ./docs/img/README_md_imgs/AWS-Partner.jpeg
   :alt: AWSPARTNER

on-boarding
~~~~~~~~~~~

1. ``make clouds``
2. ``kubfiy start-all``

welcome
=======

kubify os oss, version: 9020.0.1

turn-key devops/mlops stack, rapid development platform for services and infra on kubernetes

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

compatible with cloud providers
    * aws
    * gcp
    * azure

compatible with devops tools
    * terraform
    * terraform cdk
    * cloudformation
    * serverless framework
    * helm and kustomize

stop local kubernetes kind cluster ``kubify --down``

ideolegy of this poc: "if it works on my laptop, it will work in dev/uat/prod cloud/onprem k8s the same" (making dreams come true here)

https://kubify-os.readthedocs.io/en/latest/index.html

happy coding and enjoy

docs
~~~~

1. https://kubify-os.readthedocs.io
2. CONTRIBUTING.rst or/and USAGE.rst