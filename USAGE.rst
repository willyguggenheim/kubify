To use the python package
=========================

You can ``import kubify`` (we ship to PyPi), and then you can override
any folder (such as terraform or services folders) by having folder with
the same name in your repo.

See ``./examples/simple`` for Python Package usage example.

To run this repo directly
=========================

To contribute to Kubify Open Source (and I hope you do), then clone this
repo and:

1. ``make cloud cloud=[aws|gcp|azure]``
2. ``make local``
3. ``make local start-all``
4. ``make local [service]``

All the dependant services will start and will listen for code changes
as well. Efficiently edit the entire codebase.

To install directly on workstation
==================================

To install directly on your workstation (instead of just using the
container):

1. apple: ``make mac``
2. ubuntu, debian and other debian-based: ``make deb``
3. rhel, centos and other epel-based: ``make epel``

Environment Isolation
=====================

Security Minute: You should not give prod access to anyone (but devs
need to debug urgent issue in prod). How?

.. code:: bash

   cd services/example-node-complex-svc
   make local prod

What Just Happened?
===================

You are hot patching many services locally (and with the full real
environment) without access to data, but with the full real prod!
Kubernetes can be amazing, and it is, with Kubify..

Contributing Workflow Patterns
==============================

1. DevContainer
2. Invoke Python Directly (pull image if missing tools)
3. Tox (multi-python testing)
4. Install Directly and Invoke Python Directly


# TODO: put link to automatic gitops docs
# TODO: multi-cloud ArgoCD Helm-Native automation README explainer here
# TODO: rapid testing explainer here