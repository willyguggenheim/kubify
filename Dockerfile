# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/doc/supported-tags.md
FROM nvcr.io/nvidia/cuda:11.7.0-runtime-ubuntu22.04
# FROM willy0912/kubify-local:main
# FROM willy0912/kubify-local:v

WORKDIR /src/kubify/
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
# for good security
RUN apt install -y  --no-install-recommends python3 software-properties-common
RUN apt install -y  --no-install-recommends sudo zsh bash git ansible awscli make wget apt-utils
RUN apt install -y  --no-install-recommends python3-alembic python3-flask-migrate
# Tox Multi-Py tests:
RUN add-apt-repository ppa:deadsnakes/ppa && apt update
RUN apt install -y  --no-install-recommends python3.7 python3.8 python3.9 python3.10
# APT Deps can go here:
RUN apt install -y  --no-install-recommends python3-alembic python3-flask-migrate curl
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/8.5.13/flyway-commandline-8.5.13-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-8.5.13/flyway /usr/local/bin/

# Install EKS Control
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# For full install (but CICD env sets KUBIFY_CI=1 at runtime to override this default):
ENV KUBIFY_CI 0
ENV KUBIFY_VERBOSE 0

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
COPY *.md .
COPY *.rst .
RUN apt install -y  --no-install-recommends libxml2 libxml2-dev libxslt-dev
RUN pip install Cython

# Dev
RUN pip install -e .[develop]

# Terraform:
# RUN git clone https://github.com/riywo/anyenv ~/.anyenv
# RUN echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> /etc/profile.d/anyenv.sh
# RUN echo 'eval "$(anyenv init -)"' >> /etc/profile.d/anyenv.sh
RUN git clone https://github.com/tfutils/tfenv ~/tools/tfenv
RUN ln -s ~/tools/tfenv/bin/* /usr/local/bin
RUN apt install -y  --no-install-recommends unzip zip tar gzip
RUN tfenv install 1.2.4
RUN tfenv use 1.2.4
ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.3/terragrunt_linux_amd64 /usr/local/bin/terragrunt-amd64
ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.3/terragrunt_linux_arm64 /usr/local/bin/terragrunt-arm64
RUN chmod +x /usr/local/bin/terragrunt-*
RUN terragrunt-arm64 --version && ln -s /usr/local/bin/terragrunt-arm64 /usr/local/bin/terragrunt
RUN terragrunt-amd64 --version && unlink /usr/local/bin/terragrunt
RUN terragrunt-amd64 --version && ln -s /usr/local/bin/terragrunt-amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt

# Clean
RUN make clean

RUN apt-get update
RUN apt install -y software-properties-common
RUN apt-get upgrade -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y python3.7 python3.8 python3.9 python3.10
RUN apt-get install -y python3-pip awscli

# Cache
COPY setup.py .
RUN stat README.rst || touch README.rst
RUN stat USAGE.rst || touch USAGE.rst
RUN pip install -e .[develop]
RUN pip install -e .[tests]
RUN pip install -e .[extras]

# Code
COPY setup.py .
COPY *.md .
COPY *.rst .
RUN pip install -e .[develop]

COPY . .

# Build
RUN make lint && make help && make pythons && make pip && make security && make coverage && make package

# Install
RUN pip install -e .

RUN apt-get clean autoclean
RUN apt-get autoremove --yes

# Test
RUN make test

# Default is to run Tests and listen for folder changes (similar to skaffold, useful for rapid testing the actual python module in this repo):
CMD make test && ls -alR > folder_listen_dates.txt && while [ "`ls -alR`" != "`cat folder_listen_dates.txt`" ]