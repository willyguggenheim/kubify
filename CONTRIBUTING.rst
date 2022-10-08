.. highlight:: shell

============
Contributing
============

`make pip` # to install pip dev dependancies or `make develop` to install all dependancies
`make pythons` # test in all supported versions of python in parallel
`make docker` # or click devcontainer green button

`make security` # check code security with bandit scanner

`make test` # run all pytest tests in parallel
`make lint` # run linter tools in all langauges in repo
`make format` # autofix `make lint` findings

`make rapid` # to test & optionally version+push