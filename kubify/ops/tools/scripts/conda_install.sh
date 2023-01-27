#!/bin/bash

brew bundle || true
mkdir -p ~/._kubify_tools
curl -o ~/._kubify_tools/miniconda-install-aarch64.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
curl -o ~/._kubify_tools/miniconda-install-x86_64.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
chmod +x ~/._kubify_tools/miniconda-install*.sh
uname -m | grep arm && ~/._kubify_tools/miniconda-install-aarch64.sh -b -p /opt/conda || true
uname -m | grep aarch && ~/._kubify_tools/miniconda-install-aarch64.sh -b -p /opt/conda || true
uname -m | grep amd && ~/._kubify_tools/miniconda-install-x86_64.sh -b -p /opt/conda || true
uname -m | grep x86_64 && ~/._kubify_tools/miniconda-install-x86_64.sh -b -p /opt/conda || true
conda info