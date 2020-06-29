#!/bin/bash

sudo apt-get update && sudo apt-get install -y g++ python3 python3-dev python3-pip libffi-dev openssl
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

#apk add --no-cache --update g++ python3-dev libffi-dev openssl openssl-dev sudo curl
#echo "Set disable_coredump false" >> /etc/sudo.conf
#apk add --no-cache python3 py3-pip
#apk add --no-cache docker
pip3 install --upgrade setuptools
pip3 install --upgrade awscli
cd /usr/local/bin && \
curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip