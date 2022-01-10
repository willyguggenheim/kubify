FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y software-properties-common apt-transport-https && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible
ADD ./ /tmp/builder
RUN ansible-playbook --connection=local --inventory=127.0.0.1, /tmp/builder/playbook.yml && rm -rf /tmp/builder