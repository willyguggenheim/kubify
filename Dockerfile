FROM nvidia/cuda:11.7.1-base-ubuntu20.04

# docker variables
WORKDIR /var/folders/kubify
ENV DEBIAN_FRONTEND=noninteractive
ENV KUBIFY_TOOLS=/root/._kubify_tools
ENV KUBIFY_UNIQUE_COMPANY_ACRONYM=kubify-oss

# conda config
ENV CONDA_DIR /opt/conda
ENV PATH=${PATH}:/opt/conda/bin

# apt cache
RUN apt update && apt install -y make sudo
COPY apt.lock .
RUN xargs apt -y install <apt.lock
COPY Makefile .

# node install
ENV NVM_DIR=${KUBIFY_TOOLS}/nvm
ENV PATH=${PATH}:$NVM_DIR/versions/node/v$NODE_VERSION/bin
ENV NODE_VERSION=18.13.0
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
RUN mkdir -p $NVM_DIR
RUN make node

# terraform install
ENV TFENV_TERRAFORM_VERSION=1.3.7
ENV PATH=${PATH}:/root/._kubify_tools
RUN make tfenv tfsec

# kubectl install
RUN make kubectl

# apt update
COPY apt.lock .
RUN make apt

# python cache
COPY setup.py .
COPY Makefile .
COPY README.rst .
COPY USAGE.rst .
COPY .bandit.yml .
RUN pip install --ignore-installed PyYAML
RUN pip install --upgrade pip requests
COPY kubify/ops/terraform ./ops/terraform
RUN make security pip package
ENV PATH=${PATH}:/var/folders/kubify/kubify/ops/tools/scripts

# python update
COPY . .
RUN make develop
RUN make clean