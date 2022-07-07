Welcome!
========

Kubify OS, Version: 9003.1.7

Well hello there! Welcome to Kubify. The Turn-Key DevOps/MLOps OS Developer-First Stack.

Who is this for?
================

Data Scientists/Devs/DevOps who want self service.

To rapid develop many services/models fast simultaneously on full real
environment.

Why?
====

Because Docker-Compose and Terraform are 2 different tools, so I fixed
it.

First class rapid testing, all your services listening for folder
changes, so you can code fast, really fast.

If it works on your laptop, it works in prod.

How?
====

DevEx First Class Ideology

.. figure:: ./docs/img/README_md_imgs/the-future.gif
   :alt: FUTUREOFDEVOPS9000

   FUTUREOFDEVOPS9000

Usage?
======

See ``USAGE.rst``

Infra Diagram?
==============

See ``terraform/README.rst``

.. figure:: ./docs/img/README_md_imgs/KUBIFY_BRAND_IDENTITY_1.png
   :alt: LOGO

   LOGO

|Docker| |PyPi| |PyUp| |Docs|

Magic? Yes. Pure Magic.

This is a python package and a docker image (multi-arch).

1. PyPi
2. DockerHub


Cloud:

1. `make cloud cloud=aws``
2. (optional) `make cloud cloud=gcp` # TODO: enable for multi-cloud site-reliability backing AWS
3. (optional) `make cloud cloud=azure`

You have a redundant cloud!


Usage:

1. `pip install kubify`
2. (optional) have a services folder (see examples/simple)
3. (optional) have a terraform folder (see examples/simple)
4. then use the python functions or cli

Enjoy Rapid Testing!


Contributing:

A. open with DevContainer in IDE of your choice
B. tox all python environments `make pythons` (envs go in `./.tox/[env]/bin/python3`)
C. `make docker`
D. install develop with pip `make pip`
E. test on all versions of python `make pythons`
F. `make test`
G. your python development version/workflow of choice 

Happy Coding!


Who are you?
============

I have a ton of MLOps and DevOps experience. I want to build an open source turn-key MLOps/DevOps stack, developer-first, self-service and redunant, as well as lowest cost (arm/spot) and scalable.

I am looking for contributors to build Kubify OS into a full-force turn-key DevEx solution.


Please contribute!
==================

We all want self service turn key. It has arrived. No more K8s pains.
Please contribute.

.. figure:: ./docs/img/README_md_imgs/level-up.gif
   :alt: FUTUREOFDEVOPS9001

   FUTUREOFDEVOPS9001

.. |Docker| image:: https://github.com/willyguggenheim/kubify/actions/workflows/docker-image.yml/badge.svg?branch=main
   :target: https://github.com/willyguggenheim/kubify/actions/workflows/docker-image.yml
.. |PyPi| image:: https://img.shields.io/pypi/v/kubify.svg
   :target: https://pypi.python.org/pypi/kubify
.. |PyUp| image:: https://pyup.io/repos/github/willyguggenheim/kubify/shield.svg
   :target: https://pyup.io/repos/github/willyguggenheim/kubify/
.. |Docs| image:: https://readthedocs.org/projects/kubify/badge/?version=latest
   :target: hhttps://kubify.readthedocs.io/en/latest/?version=latest

TODO: Implement DR Automation
=============================

.. figure:: ./docs/img/README_md_imgs/kubify-arch.drawio.png
   :alt: TURN_KEY_DEVOPS_RAPID_TESTER

   TURN_KEY_DEVOPS_RAPID_TESTER

Kubify has been blessed by AWS.

.. figure:: ./docs/img/README_md_imgs/AWS-Partner.jpeg
   :alt: AWSPARTNER

   AWSPARTNER