FROM alpine as build

RUN apk add --no-cache curl unzip

# AWS cli
WORKDIR /out
RUN curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip

# Kubectl
RUN curl --silent -LO \
        https://storage.googleapis.com/kubernetes-release/release/`curl \
        -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && kubectl version --client


# ---

FROM python:slim as slim

COPY --from=build /out/aws /tmp/aws
RUN cd /tmp/aws && ./install
COPY --from=build /usr/local/bin/kubectl /usr/bin/
COPY --from=alpine/helm /usr/bin/helm /usr/bin
COPY --from=hashicorp/terraform /bin/terraform /usr/bin

ENTRYPOINT ["/bin/bash"]


# ---

FROM slim as latest

RUN apt update 1> /dev/null && apt upgrade -y 1>/dev/null \
    && apt install -y 1> /dev/null \
    bash bash-completion \
    curl wget \
    git \
    sudo \
    tmux tree vim watch
RUN /bin/bash -c "source /usr/share/bash-completion/bash_completion"
RUN echo ". /etc/profile.d/bash_completion.sh" >> /etc/skel/.bashrc \
    && echo "complete -C `which aws_completer` aws" >> /etc/skel/.bashrc \
    && echo "source <(helm completion bash)" >> /etc/skel/.bashrc \
    && echo "source <(kubectl completion bash)" >> /etc/skel/.bashrc \
    && terraform -install-autocomplete


ENV SHELL=/bin/bash
ENV HOME=/home/user
ENV AWS_SHARED_CREDENTIALS_FILE=$HOME/.aws/credentials
ENV AWS_CONFIG_FILE=$HOME/.aws/config

WORKDIR $HOME
RUN chmod -R 777 /home
RUN cp -v /etc/skel/.bashrc $HOME/.bashrc
