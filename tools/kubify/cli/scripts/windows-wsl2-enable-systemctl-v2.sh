#!/usr/bin/env bash


set -e

# https://superuser.com/questions/1556609/how-to-enable-systemd-on-wsl2-ubuntu-20-and-centos-8
sudo mv /bin/systemctl /bin/systemctl.old || true
wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py
sudo mv ./systemctl.py /bin/systemctl
sudo chmod +x /bin/systemctl

# test it
systemctl list-units --type=service

# success
echo "it worked (probably WSL2)!  .. NOTE: this same script should also work with containers"
