#!/bin/bash

stat ~/.bashrc && source ~/.bashrc || echo "No ~/.bashrc file found"
source activate base
conda --version && conda update -y -n base -c defaults conda
conda info --envs | grep kubify || conda create -y --name kubify
conda info | grep "active environment" | grep base && echo "now run: source activate kubify"
conda install -y -c conda-forge check-manifest