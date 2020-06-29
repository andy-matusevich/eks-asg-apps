#!/bin/sh -leo pipefail

apk add --no-cache --update g++ python3-dev libffi-dev openssl openssl-dev sudo curl
echo "Set disable_coredump false" >> /etc/sudo.conf
apk add --no-cache python3 py3-pip
pip3 install --upgrade setuptools
pip3 install --upgrade awscli
cd /usr/local/bin && \
curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip