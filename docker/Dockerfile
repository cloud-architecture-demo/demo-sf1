FROM jenkins/inbound-agent

USER root

## Install git, Maven, and other depends
RUN apt update                                   && \
    apt install -y git                              \
                   maven                            \
                   apt-transport-https              \
                   ca-certificates                  \
                   curl                             \
                   gnupg2                           \
		           build-essential                  \
                   software-properties-common    && \

## install openjdk8
    curl -fsSL https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -    && \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/                    && \
    apt-get update && apt-get install -y adoptopenjdk-8-hotspot                                 && \

## Install docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -                                     && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"    && \
    apt update                                                                                                  && \
    apt install -y docker-ce                                                                                    && \
    usermod -aG docker jenkins                                                                                  && \

## Install AWS cli  kubectl
    wget --quiet https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
    unzip awscli-bundle.zip                                         && \
    ./awscli-bundle/install -b ~/bin/aws                            && \
    wget --quiet -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl    && \
    chmod +x /usr/local/bin/kubectl                                                                                                     && \

## Install GOlang
    curl -O https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz && \
    tar xvf go1.12.7.linux-amd64.tar.gz                          && \
    chown -R root:root ./go                                      && \
    mv go /usr/local                                             && \
    rm go1.12.7.linux-amd64.tar.gz                               && \
    apt-get clean                                                && \
    rm -rf /var/lib/apt/lists/*

## Configure Jenkins User
USER 1000
ENV HOME="/home/jenkins"
ENV GOPATH="$HOME/work"
ENV PATH="$PATH:/home/jenkins/bin/:/usr/local/go/bin:$GOPATH/bin"

RUN mkdir $HOME/work && \
    chown jenkins:jenkins $HOME/work
