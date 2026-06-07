FROM jenkins/inbound-agent:latest-jdk17

ARG TERRAFORM_VERSION=1.8.5
ARG KUBECTL_VERSION=v1.30.3
ARG HELM_VERSION=3.15.4
ARG TRIVY_VERSION=0.53.0

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ansible \
      ca-certificates \
      curl \
      docker.io \
      git \
      gnupg \
      jq \
      python3 \
      python3-pip \
      unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip

RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscli.zip \
    && unzip /tmp/awscli.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/aws /tmp/awscli.zip

RUN curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tar.gz \
    && tar -xzf /tmp/helm.tar.gz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
    && rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

RUN curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" -o /tmp/trivy.tar.gz \
    && tar -xzf /tmp/trivy.tar.gz -C /tmp trivy \
    && mv /tmp/trivy /usr/local/bin/trivy \
    && rm /tmp/trivy.tar.gz

RUN ansible-galaxy collection install amazon.aws kubernetes.core

USER jenkins
