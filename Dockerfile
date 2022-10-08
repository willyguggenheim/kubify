FROM nvidia/cuda:11.7.1-base-ubuntu20.04

WORKDIR /src/kubify

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR /opt/conda
ENV NODE_VERSION=14.18.1
ENV NVM_DIR=$HOME/.kubify_nvm

RUN mkdir -p $NVM_DIR
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH=/opt/conda/bin:$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN apt update && apt install -y make sudo curl git

COPY Makefile .
RUN make node
COPY apt.lock .
RUN make apt
COPY setup.py .
COPY Makefile .
COPY README.rst .
COPY USAGE.rst .
COPY .bandit.yml .
RUN pip install --ignore-installed PyYAML
RUN pip install --upgrade pip
COPY kubify/ops/terraform ./ops/terraform
RUN make tfenv tfsec kubectl
RUN make security pip package

COPY . .
RUN make develop
RUN make clean