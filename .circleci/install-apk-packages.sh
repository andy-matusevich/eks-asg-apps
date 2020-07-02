#!/bin/sh -leo pipefail

apk add --no-cache --update --no-progress g++ python3-dev libffi-dev openssl openssl-dev sudo curl
echo "Set disable_coredump false" >> /etc/sudo.conf
apk add --no-cache --no-progress python3 py3-pip bash
pip3 install --upgrade setuptools --progress-bar off
pip3 install --upgrade awscli --progress-bar off
cd /usr/local/bin && \
curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip