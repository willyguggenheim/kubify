.. highlight:: shell

============
Contributing
============

Contributions are welcome, and they are greatly appreciated! Every little bit
helps, and credit will always be given.

You can contribute in many ways:

Types of Contributions
----------------------

Report Bugs
~~~~~~~~~~~

Report bugs at https://github.com/willyguggenheim/kubify/issues.

If you are reporting a bug, please include:

* Your operating system name and version.
* Any details about your local setup that might be helpful in troubleshooting.
* Detailed steps to reproduce the bug.

Fix Bugs
~~~~~~~~

Look through the GitHub issues for bugs. Anything tagged with "bug" and "help
wanted" is open to whoever wants to implement it.

Implement Features
~~~~~~~~~~~~~~~~~~

Look through the GitHub issues for features. Anything tagged with "enhancement"
and "help wanted" is open to whoever wants to implement it.

Write Documentation
~~~~~~~~~~~~~~~~~~~

kubify could always use more documentation, whether as part of the
official kubify docs, in docstrings, or even on the web in blog posts,
articles, and such.

Submit Feedback
~~~~~~~~~~~~~~~

The best way to send feedback is to file an issue at https://github.com/willyguggenheim/kubify/issues.

If you are proposing a feature:

* Explain in detail how it would work.
* Keep the scope as narrow as possible, to make it easier to implement.
* Remember that this is a volunteer-driven project, and that contributions
  are welcome :)

Get Started!
------------

Ready to contribute? Here's how to set up `kubify` for local development.

1. Fork the `kubify` repo on GitHub.
2. Clone your fork locally::

    $ git clone git@github.com:your_name_here/kubify.git

3. Install your local copy into a virtualenv. Assuming you have virtualenvwrapper installed, this is how you set up your fork for local development::

    $ mkvirtualenv kubify
    $ cd kubify/
    $ python3 setup.py develop

4. Create a branch for local development::

    $ git checkout -b name-of-your-bugfix-or-feature

   Now you can make your changes locally.

5. When you're done making changes, check that your changes pass flake8 and the
   tests, including testing other Python versions with tox::

    $ flake8 kubify tests
    $ python3 setup.py test or pytest
    $ tox

   To get flake8 and tox, just pip install them into your virtualenv.

6. Commit your changes and push your branch to GitHub::

    $ git add .
    $ git commit -m "Your detailed description of your changes."
    $ git push origin name-of-your-bugfix-or-feature

7. Submit a pull request through the GitHub website.

Pull Request Guidelines
-----------------------

Before you submit a pull request, check that it meets these guidelines:

1. The pull request should include tests.
2. If the pull request adds functionality, the docs should be updated. Put
   your new functionality into a function with a docstring, and add the
   feature to the list in README.md.
3. The pull request should work for Python 3.7 and 3.8, 3.9, 3.10, and for PyPy. Check
   https://travis-ci.com/willyguggenheim/kubify/pull_requests
   and make sure that the tests pass for all supported Python versions.

Tips
----

To run a subset of tests::

$ pytest tests.test_kubify


Deploying
---------

A reminder for the maintainers on how to deploy.
Make sure all your changes are committed (including an entry in HISTORY.rst).
Then run::

$ bump2version patch # possible: major / minor / patch
$ git push
$ git push --tags

Travis will then deploy to PyPI if tests pass.

Development workflow patterns:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A) `make pip`

Test the CICD before PR is ready for review:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`make docker`
# TODO: local integration test make command (local and cloud)

Usage?
======

See ``USAGE.rst``

Infra Diagram?
==============

See ``kubify/ops/terraform/README.rst``

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

Optional: "terraform" folder/submodule

Optional: "services/[]" folders/submodules


Rapid Test Multiple Services/Models at the Same Time

``kubify start-all`` or ``kubify start service [string or list]``

Enjoy Rapid Testing!

Note
~~~~

Please see `./USAGE.rst` !!

BUT WHY
~~~~~~~

Well hello there! Welcome to Kubify. The Turn-Key DevOps/MLOps OS Developer-First Stack.

But Why?
========

Because Docker-Compose and Terraform are 2 different tools, so I fixed
it.

First class rapid testing, all your services listening for folder
changes, so you can code fast, really fast.

The world needs a Turn-Key Cloud OS solution, so Developers can focus.

Developers need to be able to quickly code and test multiple services, on a REAL full environment.

There is a Developer-Centric need (startup/greenfield/migration/smb) for getting an entire cloud up and running in minutes, rather than years.

Everything you build in Kubify has redundancy ``(dr, backups and active-active)`` and scalability in 2 regions, at the lowest possible cost ``(multiarch, spot, atom processor, spot gpu rapid de-scaling, mlops smart scaling, redundant scalers and more)``.

This is what true turn key feels like. DevOps in 1 day. Developer friendly. Purpose built for Data Scientists and Machine Learning, as well as Developers building services and cloud. Autopilot for DevOps, so your DevOps team can focus on company goals.

Developers and Data Scientists want Self Service. 

AutoPilot-MLOps DevOps-as-a-Package.

Pro Tips
~~~~~~~~

1) Your services (that have databases defined in kubify.yml) need to have Migrations/Seeds. This way when someone clones your repo, the service simply works with 1 simple command `kubify start` and is 100% ready to code.

2) If you "sync" (kubify.yml) your site-packages/node_modules/cmake_cache/apt_cache/yum_cache/apk_cache then your service will load/re-load super fast and you can code multiple services at once with 1 simple `kubify start` command.

3) Please Contribute to this Open Source Repository, so we can help each other build amazing things!!

If you don't have admin rights on your workstation (NO PROBLEM, have thought of everything):
    A) have your IT install Docker if you still want to rapid test locally
        * docker installs automatically if not installed
    B) or use VSCode/JupyterHub/WebShell (built in to the `./kubify/ops/services/datascience/`)
        * you can even use an ipad to code (maximum company security)

Usage
~~~~~

Use the pip package that this repo releases.

`pip install kubify`

Then (optionally) have a "terraform" folder (or git submodule) in your repo (or use the existing built-in terraform folder automatically).

Then have a "services" folder (and bring in the examples from `./kubify/ops/services`). 

Contributing
~~~~~~~~~~~~

Same pattern, but you do that inside of this repo itself (using `make develop`).

# Fix most of Flake8 Findings

`for f in `find . -name "*.py"`; do autopep8 --in-place --select=W292 $f; done`