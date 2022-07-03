# Pro Tips

1) Your services (that have databases defined in kubify.yml) need to have Migrations/Seeds. This way when someone clones your repo, the service simply works with 1 simple command `kubify start` and is 100% ready to code.

2) If you "sync" (kubify.yml) your site-packages/node_modules/cmake_cache/apt_cache/yum_cache/apk_cache then your service will load/re-load super fast and you can code multiple services at once with 1 simple `kubify start` command.

3) Please Contribute to this Open Source Repository, so we can help each other build amazing things!!

# More Pro Tips

If you don't have admin rights on your workstation (NO PROBLEM, have thought of everything):
    A) have your IT install Docker if you still want to rapid test locally
        * docker installs automatically if not installed
    B) or use VSCode/JupyterHub/WebShell (built in to the `./services/datascience/`)
        * you can even use an ipad to code (maximum company security)

# Usage?

Use the pip package that this repo releases.

`pip install kubify`

Then (optionally) have a "terraform" folder (or git submodule) in your repo (or use the existing built-in terraform folder automatically).

Then have a "services" folder (and bring in the examples from `./services`). 

# Contributing?

Same pattern, but you do that inside of this repo itself (using `make develop`).

# Fix most of Flake8 Findings

`for f in `find . -name "*.py"`; do autopep8 --in-place --select=W292 $f; done`