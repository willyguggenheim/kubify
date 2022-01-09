# This is the Latest LTS (still as of January 2022):
FROM ubuntu:20.04

# Might be important, so just in case:
USER root
ENV USER=root
RUN chgrp root /etc/passwd && chmod ug+rw /etc/passwd
#######

RUN apt update
# Vegas is same time zone as Los_Angeles (needed for silent install of snapd):
ENV TZ=Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN DEBIAN_FRONTEND=noninteractive apt install -y snapd

# For full install (but CICD env sets KUBIFY_CI=1 at runtime to override this default):
ENV KUBIFY_CI 0

# Add your DevSecOps OS Hardening things here:
RUN apt update && apt -y upgrade
#####

# Your services folder gets mounted automatically (for Kubify's rapid testing magic):
RUN mkdir -p /src/kubify/tools
ADD ./src/kubify /src/kubify/src/kubify

# Copying the automation magic here (for building a trusted hardened container):
RUN mkdir -p /etc/ansible
ADD ./ansible.cfg /etc/ansible/

RUN apt update
RUN apt install -y git python3 ansible python3-pip curl wget
RUN git config --global user.name "Willy Guggenheim"
RUN git config --global user.email "willy@gugcorp.com"

# PLEASE NOTE: https://snapcraft.io/store
#  All of your Kubify services that have databases should have schema/seeds (for automated+rapid tests+infra to work properly) !! <- LOOK HERE PLEASE !!
# RUN systemctl start snapd && DEBIAN_FRONTEND=noninteractive snap install flyway alembic
RUN apt install -y python3-alembic python3-flask-migrate sudo
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/8.3.0/flyway-commandline-8.3.0-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-8.3.0/flyway /usr/local/bin/

# Install Kindest Kind (local Kubernetes cluster)
#  TODO: Remove this after the below is switched from "kubify install" to "kubify up" (after making "up" compatible with docker)
#  TODO: Browser automation through container (using Chrome Engine docker->host or similar)
#  TODO: Same for PostMan
#  TODO: Ports for sames
RUN curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.1/kind-$(uname)-amd64" && \
        chmod +x ./kind && \
            mv ./kind /usr/local/bin/kind

# TODO: this is a workaround (but I will improve this)
COPY ./.aws /root/.aws
RUN ls /root/.aws || exit 1
##

# Might be important, so just in case:
COPY ./Docker-Entrypoint-User.sh /Docker-Entrypoint-User.sh
ENTRYPOINT /Docker-Entrypoint-User.sh
#######

# TODO: Make sure "install" is upgraded to work with full local cluster testing (like "up" does) 
#  in a way that does not break cicd usage (willy created "install" for cicd usage originally)
RUN cd /src/kubify && \
    ./src/kubify/tool/kubify install && \
    rm -rf /src/kubify
##

######
RUN rm -rf /root/.aws
##

RUN echo "_______________________________________________________________________________"
RUN echo "THANK YOU FOR CHOOSING KUBIFY, YOUR AN EPIC CODE MACHINE, HAPPY RAPID TESTING!!"