Turn Key DevOps/MLOps DR-Enabled Scalable Lowest-Cost Full Rapid Testing Stack

Ideoligy: If it works on your laptop/test/notebook, it works in PROD (yup)

How??

.. figure:: ./docs/img/README_md_imgs/the-future.gif
   :alt: FUTUREOFDEVOPS9000

Full Kubernetes Local Rapid Coding Within A Real Environment, Unique Workflow to Win even Faster

With Services Listening For Code Changes or Hot Reloading, On The Real Infra CodeBase While You Code

In An Effort To Introduce Early Regression Testing to The Development Day, Without Slowing Anyone Down

Contributing:
============

A. devcontainer or container
B. ``tox``
C. ``make docker``
D. ``make pip``
E. ``make pythons``
F. ``make test``
G. and more ..

============
Contributing
============

`make pip` # to install pip dev dependancies or `make develop` to install all dependancies

`make pythons` # test in all supported versions of python in parallel

`make docker` # or click devcontainer green button

`make security` # check code security with bandit scanner

`make test` # run all pytest tests in parallel

`make lint` # run linter tools in all langauges in repo`make format` # autofix `make lint` findings

`make rapid` # to test & optionally version+push

recommended workflow: 

*click the devcontainer (green button) in github workspaces/vscode (or your ide of choice)!*

most efficient on-boarding workflow: 

*simply click the dot "." key on your keyboard in github to start coding!*

contributing command
====================

it's as simple as `git commit [] && make rapid` to test+regression+version+push your changes 
    * to this kubify repository as a contributor
    * to the your cicd cloud kubify pipeline(s)

a: contributing.rst
   * includes efficient workflows for contributing to this repo (and for any custom installs) enjoy
b: dev container vscode
   * click the dev container button in your ide of choise (example: visual studio code's green button)
c: github workspaces
   * super efficient on-boarding use case (for installs and contributing): click "."" key in github

releasing
=========

``make latest``

happy coding