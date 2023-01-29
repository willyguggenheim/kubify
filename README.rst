dev toolkit for kubernetes multi-cloud multi-service

release targets
===============

* conda https://anaconda.org/kubify/kubify
* docker/podman https://hub.docker.com/repository/docker/willy0912/kubify
* pip/pypa/poerty https://pypi.org/project/kubify

.. |artifacts_release| image:: https://github.com/willyguggenheim/kubify/actions/workflows/docker-pypi-conda.yml/badge.svg?branch=main
   :target: https://hub.docker.com/repository/docker/willy0912/kubify
.. |docs_release| image:: https://readthedocs.org/projects/kubify-os/badge/?version=latest
   :target: https://kubify.readthedocs.io/en/latest/?version=latest

on-boarding
===========

1. ``make clouds``
2. ``kubfiy start-all``

welcome
=======

kubify os oss, version: 9020.0.26

getting started
===============

local
=======

.. code-block:: bash

   $ [pip|conda] install kubify
   $ kubify --up
   $ kubify --start-all
   $ cd services[][] && kubify --start
   $ kubify --down

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

"if it works on my computer, it will work in the cloud"

cloud
=====

.. code-block:: bash

   $ make clouds
   $ make clouds-delete

docs
====

1. https://kubify-os.readthedocs.io
2. CONTRIBUTING.rst
3. USAGE.rst

.. figure:: ./docs/img/README_md_imgs/kubify-arch.drawio.png
   :alt: TURN_KEY_DEVOPS_RAPID_TESTER

aws partner
===========

.. figure:: ./docs/img/README_md_imgs/AWS-Partner.jpeg
   :alt: AWSPARTNER

enjoy the fun