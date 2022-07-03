# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/doc/supported-tags.md
FROM nvcr.io/nvidia/cuda:11.7.0-runtime-ubuntu22.04

WORKDIR /src/kubify/

# Required --build-arg variables:
ARG GIT_FIRST_LAST_NAME=local
ENV GIT_FIRST_LAST_NAME=${GIT_FIRST_LAST_NAME}
ARG GIT_EMAIL=local
ENV GIT_EMAIL=${GIT_EMAIL}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
# for good security
RUN apt upgrade -y

# APT Deps go here:
RUN apt update
RUN apt install -y git ansible curl awscli make wget python3-alembic python3-flask-migrate sudo bash wget apt-utils
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/8.5.13/flyway-commandline-8.5.13-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-8.5.13/flyway /usr/local/bin/

# Install EKS Control
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# For full install (but CICD env sets KUBIFY_CI=1 at runtime to override this default):
ENV KUBIFY_CI 0
ENV KUBIFY_VERBOSE 0

# Add your DevSecOps OS Hardening things here:
RUN apt update && apt -y upgrade
#####

# Copying the automation magic here (for building a trusted hardened container):
RUN mkdir -p /etc/ansible
RUN git config --global user.name "${GIT_FIRST_LAST_NAME}"
RUN git config --global user.email "${GIT_EMAIL}"

# Install Kindest Kind (local Kubernetes cluster)
RUN curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.14.0/kind-$(uname)-amd64" && \
        chmod +x ./kind && \
            mv ./kind /usr/local/bin/kind

# Your services folder gets mounted automatically (for Kubify's rapid testing engine):
COPY ./ansible.cfg /etc/ansible/
COPY ./ansible /tmp/ansible
RUN rm -rf /src/kubify/.git /src/kubify/
RUN ansible-playbook --connection=local "/tmp/ansible/install_kubify_on_debian_ubuntu_and_wsl2.yaml" --ask-become-pass -e ansible_python_interpreter=`which python3`
COPY setup.py .
COPY Makefile .
COPY *.md .
COPY *.rst .
RUN apt install -y libxml2 libxml2-dev libxslt-dev
RUN pip install Cython

# Security Checks:
RUN make security

# Build Package
RUN make pip

# Terraform:
# RUN git clone https://github.com/riywo/anyenv ~/.anyenv
# RUN echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> /etc/profile.d/anyenv.sh
# RUN echo 'eval "$(anyenv init -)"' >> /etc/profile.d/anyenv.sh
RUN git clone https://github.com/tfutils/tfenv ~/tools/tfenv
RUN ln -s ~/tools/tfenv/bin/* /usr/local/bin
RUN apt install -y unzip zip tar gzip
RUN tfenv install 1.2.4
RUN tfenv use 1.2.4
ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.3/terragrunt_linux_amd64 /usr/local/bin/terragrunt-amd64
ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.3/terragrunt_linux_arm64 /usr/local/bin/terragrunt-arm64
RUN chmod +x /usr/local/bin/terragrunt-*
RUN terragrunt-arm64 --version && ln -s /usr/local/bin/terragrunt-arm64 /usr/local/bin/terragrunt
RUN terragrunt-amd64 --version && unlink /usr/local/bin/terragrunt
RUN terragrunt-amd64 --version && ln -s /usr/local/bin/terragrunt-amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt

# Code:
COPY . .

# Clean:
RUN make clean
RUN rm -rf /tmp/* /var/tmp/*
RUN rm -rf ./services/*/*/secr* ./.git
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

# Package:
RUN make package