#!/bin/bash

brew bundle || true
mkdir -p ./kubify_tools
curl -o ./kubify_tools/miniconda-install-aarch64.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
curl -o ./kubify_tools/miniconda-install-x86_64.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
chmod +x ./kubify_tools/miniconda-install*.sh
uname -m | grep arm && ./kubify_tools/miniconda-install-aarch64.sh -b -p /opt/conda || true
uname -m | grep aarch && ./kubify_tools/miniconda-install-aarch64.sh -b -p /opt/conda || true
uname -m | grep amd && ./kubify_tools/miniconda-install-x86_64.sh -b -p /opt/conda || true
uname -m | grep x86_64 && ./kubify_tools/miniconda-install-x86_64.sh -b -p /opt/conda || true
conda info