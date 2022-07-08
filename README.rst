Welcome!
========

Kubify OS, Version: 9005.0.6

Well hello there! Welcome to Kubify. 

The Turn-Key DevOps/MLOps OS Developer-First Stack.

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

1. Automated EKS/GKE/AKS.
2. Automated DR/SelfService/OnBoarding.
2. Rapid Test/Develop many Services/Models Simultaneously
.
Turn Key DevOps/MLOps DR-Enabled Scalable Lowest-Cost Full Rapid Testing Stack. 

Ideoligy: If it works on your laptop, it works in prod.

How?
====

DevEx First Class Ideology

.. figure:: ./docs/img/README_md_imgs/the-future.gif
   :alt: FUTUREOFDEVOPS9000

Usage?
======

See ``USAGE.rst``

Infra Diagram?
==============

See ``terraform/README.rst``

.. figure:: ./docs/img/README_md_imgs/KUBIFY_BRAND_IDENTITY_1.png
   :alt: LOGO

|Docker| |PyPi| |PyUp| |Docs|

Magic? Yes. Pure Magic.

This is a python package and a docker image (multi-arch).

1. PyPi
2. DockerHub


Cloud:

``make clouds``

You have a redundant cloud!


Usage of published PyPi "kubify" package in your repo:

``pip install kubify``

Optional: "terraform" folder (or git submodule of your terraform main repo, default it uses the terraform folder in this repo)

Optional: "services" folder (or git submodule of your services in a services folder, default it uses the services folder in this repo)


Rapid Test Multiple Services/Models at the Same Time

``kubify start-all`` or ``kubify start service [string or list]``

Enjoy Rapid Testing!


Contributing:

(choose any to contribute to the kubify python package in this repo)
A. devcontainer or container
B. ``tox``
C. ``make docker``
D. ``make pip``
E. ``make pythons``
F. ``make test``
G. and more ..

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

The future of DevOps is here. If only there was a ``make devs happy``, well there is, welcome!

.. |Docker| image:: https://github.com/willyguggenheim/kubify/actions/workflows/docker-image.yml/badge.svg?branch=main
   :target: https://github.com/willyguggenheim/kubify/actions/workflows/docker-image.yml
.. |PyPi| image:: https://img.shields.io/pypi/v/kubify.svg
   :target: https://pypi.python.org/pypi/kubify
.. |PyUp| image:: https://pyup.io/repos/github/willyguggenheim/kubify/shield.svg
   :target: https://pyup.io/repos/github/willyguggenheim/kubify/
.. |Docs| image:: https://readthedocs.org/projects/kubify/badge/?version=latest
   :target: hhttps://kubify.readthedocs.io/en/latest/?version=latest

Everything you build in Kubify has redundancy (dr, backups and active-active) and scalability in 2 regions, at the lowest possible cost (multiarch, spot, atom processor, spot gpu rapid de-scaling, mlops smart scaling, redundant scalers and more).

This is what true turn key feels like. DevOps in 1 day. Developer friendly. Purpose built for Data Scientists and Machine Learning, as well as Developers building services and cloud. Autopilot for DevOps, so your DevOps team can focus on company goals.

.. figure:: ./docs/img/README_md_imgs/kubify-arch.drawio.png
   :alt: TURN_KEY_DEVOPS_RAPID_TESTER

Kubify has been approved by AWS.

.. figure:: ./docs/img/README_md_imgs/AWS-Partner.jpeg
   :alt: AWSPARTNER

Turn Key Automated/Autopilot MLOps/DevOps OS Stack.

Self Service, Developer-Centric, lower Cloud Costs.