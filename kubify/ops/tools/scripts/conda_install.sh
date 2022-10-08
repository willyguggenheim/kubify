#!/bin/bash

mkdir -p ./kubify_tools
uname -a | grep arm && curl -o ./kubify_tools/miniconda-install.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh" || true
uname -a | grep amd && curl -o ./kubify_tools/miniconda-install.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" || true
uname -a | grep aarch && curl -o ./kubify_tools/miniconda-install.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh" || true
echo $OSTYPE | grep arwin && brew bundle || stat ./kubify_tools/miniconda-install.sh
/bin/bash ./kubify_tools/miniconda-install.sh -b -p /opt/conda || ./kubify_tools/miniconda-install.sh -b -p /opt/conda || $SHELL ./kubify_tools/miniconda-install.sh