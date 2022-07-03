# This is the Latest LTS (still as of January 2022):
FROM ubuntu:22

RUN tfenv install 1.2.4
RUN tfenv use 1.2.4

# Required --build-arg variables:
ARG GIT_FIRST_LAST_NAME=local
ENV GIT_FIRST_LAST_NAME ${GIT_FIRST_LAST_NAME}
ARG GIT_EMAIL=local
ENV GIT_EMAIL ${GIT_EMAIL}

# Might be important, so just in case:
USER root
ENV USER=root
#RUN chgrp root /etc/passwd && chmod ug+rw /etc/passwd
#######

RUN apt update
# Vegas is same time zone as Los_Angeles (needed for silent install of snapd):
ENV TZ=Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN DEBIAN_FRONTEND=noninteractive apt install -y snapd

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
ADD ./ansible.cfg /etc/ansible/
# APT Deps go here:
RUN apt update
RUN apt install -y git python3 ansible python3-pip curl awscli \
                   make wget tfsec tfenv
RUN apt install -y python3-alembic python3-flask-migrate sudo bash wget apt-utils
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/8.5.13/flyway-commandline-8.5.13-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-8.5.13/flyway /usr/local/bin/

# Install Kindest Kind (local Kubernetes cluster)
RUN curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.14.0/kind-$(uname)-amd64" && \
        chmod +x ./kind && \
            mv ./kind /usr/local/bin/kind

# Your services folder gets mounted automatically (for Kubify's rapid testing magic):
ADD . /src/kubify/
WORKDIR /src/kubify/

RUN rm -rf /src/kubify/.git /src/kubify/
RUN ./kubify install_container
RUN ./kubify _up_container || echo "supposed to fail, just doing caching"
##