FROM python:slim

ENV SHELL=/bin/bash
ENV HOME=/home/user
ENV AWS_SHARED_CREDENTIALS_FILE=$HOME/.aws/credentials
ENV AWS_CONFIG_FILE=$HOME/.aws/config

ARG TERRAFORM_VERSION=0.12.7

RUN apt update 1>/dev/null && apt upgrade -y 1>/dev/null

RUN apt install -y \
        bash bash-completion \
        curl wget unzip \
        git openssh-client openssl \
        groff \
        sudo \
        tmux tree vim watch \
        1>/dev/null

RUN echo ". /etc/profile.d/bash_completion.sh" >> /etc/skel/.bashrc

# AWS cli
RUN pip3 install --quiet --upgrade pip \
    && pip3 install --quiet awscli \
    && echo "complete -C `which aws_completer` aws" >> /etc/skel/.bashrc \
    && aws --version

# Eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin \
    && echo "source <(eksctl completion bash)" >> /etc/skel/.bashrc \
    && eksctl version

# Helm
RUN curl --silent -LO https://git.io/get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && echo "source <(helm completion bash)" >> /etc/skel/.bashrc \
    && helm version --client

# Kubectl
RUN curl --silent -LO \
        https://storage.googleapis.com/kubernetes-release/release/`curl \
        -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && echo "source <(kubectl completion bash)" >> /etc/skel/.bashrc \
    && kubectl version --client

# Terraform
RUN curl --silent -sSL \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        -o ./terraform.zip \
    && unzip ./terraform.zip -d /usr/local/bin/ \
    && rm ./terraform.zip \
    && terraform -install-autocomplete \
    && terraform version

RUN chmod -R 777 $HOME
ENTRYPOINT ["/bin/bash"]
