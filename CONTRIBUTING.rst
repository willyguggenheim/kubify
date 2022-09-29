.. highlight:: shell

============
Contributing
============

`conda activate kubify`
`make pip`
`make docker` # or use devcontainer button in your ide
`make rapid` # to push changes to branch and version them for pr
`git checkout python && git pull && conda activate kubify && make pip && kubify up && cd services/backoffice/example-node-svc && kubify start` # or use devcontainer button after git pull on python branch and then: make pip && kubify up && cd services/backoffice/example-node-svc && kubify start