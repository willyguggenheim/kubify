FROM ubuntu:18.10

ENV KUBIFY_CI 1
ENV KUBIFY_VERBOSE 1

RUN mkdir -p /src/kubify/tools
ADD ./tools/kubify /src/kubify/tools/kubify

RUN apt update && \
    apt install -y git python3 ansible python3-pip curl

RUN mkdir -p /etc/ansible
ADD ./ansible.cfg /etc/ansible/

RUN cd /src/kubify && \
    ./tools/kubify/cli/kubify install && \
    rm -rf /src/kubify