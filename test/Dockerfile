FROM python:3-alpine
COPY requirements.txt .

ENV TERRAFORM_VERSION=0.12.29

ENV PYTHONDONTWRITEBYTECODE donot

RUN apk update && apk add ca-certificates curl git openssl wget && \
    update-ca-certificates && \
    cd /tmp && \
    wget -q https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        unzip terraform_*_linux_amd64.zip -d /usr/bin && \
    rm -rf /tmp/* /var/cache/apk/* /var/tmp/*

RUN pip install --no-cache-dir -r requirements.txt
ADD infra /infra
