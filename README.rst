welcome
=======

kubify os, version: 9015.0.3

turn-key devops/mlops stack

rapid development platform


getting started
~~~~~~~~~~~~~~~

local install

    a: `pip install kubify`

    b: `conda install kubify`

local start kubernetes kind kubify rapid testing cluster ``kubify --up``

a: start all services and infra locally ``kubify --start-all``
    * deploys all terraform locally to localstack aws cloud services
    * deploys all serverless framework to localstack aws cloud services


b: listen for code changes on the service you want to work on ``kubify --start``
    1. ``cd services/[][]``
    2. ``kubify --start``
    * deploys dependant services 
    * deploys service with hot reloading (default) 
        * to code even faster, enable hot reloading in your ``kubify.yml:sync``

stop local kubernetes kind cluster ``kubify --down``

https://kubify-os.readthedocs.io/en/latest/index.html

happy coding and enjoy