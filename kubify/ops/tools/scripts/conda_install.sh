#!/bin/bash

mkdir -p $HOME/kubify_tools
uname -a | grep arm && curl -o $HOME/kubify_tools/miniconda-install.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
uname -a | grep amd && curl -o $HOME/kubify_tools/miniconda-install.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
uname -a | grep aarch && curl -o $HOME/kubify_tools/miniconda-install.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
echo $OSTYPE | grep arwin && brew bundle || stat $HOME/kubify_tools/miniconda-install.sh && /bin/bash $HOME/kubify_tools/miniconda-install.sh -b -p /opt/conda