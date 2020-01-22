#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y jq python-pip software-properties-common sshpass unzip
apt-add-repository -y -u ppa:ansible/ansible
apt-get install -y ansible
pip install python-openstackclient python-heatclient python-magnumclient
curl -O https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.19_linux_amd64.zip
unzip terraform_0.12.19_linux_amd64.zip
mv terraform /usr/local/bin/