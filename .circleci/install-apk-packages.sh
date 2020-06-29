#!/bin/sh -leo pipefail

apk add --no-cache --update g++ python3-dev libffi-dev openssl openssl-dev sudo
echo "Set disable_coredump false" >> /etc/sudo.conf
apk add --no-cache curl python3 py3-pip setuptools
apk add --no-cache docker

cd /usr/local/bin && \
curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip