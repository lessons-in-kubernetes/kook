FROM ubuntu:22.04

ARG EKSCTL_VERSION=v0.120.0
ARG KUBECTL_VERSION=v1.25.4
ARG HELM_VERSION=v3.10.2
ARG K9S_VERSION=v0.26.7
ARG HELM_DIFF_VERSION=3.6.0
ARG HELM_SECRETS_VERSION=4.2.2

RUN rm /etc/apt/apt.conf.d/docker-clean
RUN apt-get update && apt-get -y install --no-install-recommends ca-certificates wget unzip jq bash-completion git nano && apt-get clean && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-c", "-o", "pipefail"]
RUN echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc

# awscli install
RUN wget -q "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && echo "complete -C '/usr/local/bin/aws_completer' aws" >> /root/.bashrc

# eksctl install
RUN wget -q "https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz" && tar -zxvf eksctl_Linux_amd64.tar.gz && mv eksctl /usr/local/bin && echo ". <(eksctl completion bash)" >> /root/.bashrc

# kubectl install
WORKDIR /tmp
RUN wget -q "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && echo 'source <(kubectl completion bash)' >> /root/.bashrc

# krew install
RUN OS="$(uname | tr '[:upper:]' '[:lower:]')" && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && KREW="krew-${OS}_${ARCH}" && wget -q "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && tar zxvf "${KREW}.tar.gz" && ./"${KREW}" install krew && echo 'export PATH=${KREW_ROOT:-$HOME/.krew}/bin:$PATH' >> /root/.bashrc
RUN export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && kubectl krew install resource-capacity && kubectl krew install ctx && kubectl krew install ns && kubectl krew install konfig && kubectl krew install score

# helm install
RUN wget -q https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz && tar -zxvf helm-$HELM_VERSION-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm && mkdir -p /etc/bash_completion.d && helm completion bash > /etc/bash_completion.d/helm

# helm plugins install (diff, secrets)
RUN helm plugin install https://github.com/databus23/helm-diff --version v${HELM_DIFF_VERSION} && helm plugin install https://github.com/jkroepke/helm-secrets --version v${HELM_SECRETS_VERSION}

# k9s install
RUN wget -q https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && tar -zxvf k9s_Linux_x86_64.tar.gz && mv k9s /usr/local/bin/k9s 
