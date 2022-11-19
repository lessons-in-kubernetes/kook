FROM ubuntu:22.04
RUN rm /etc/apt/apt.conf.d/docker-clean
RUN apt-get update && apt-get -y install curl wget unzip jq bash-completion git
SHELL ["/bin/bash", "-c"] 

# awscli install
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && echo "complete -C '/usr/local/bin/aws_completer' aws" >> /root/.bashrc

# eksctl install
RUN curl -LO "https://github.com/weaveworks/eksctl/releases/download/v0.120.0/eksctl_Linux_amd64.tar.gz" && tar -zxvf eksctl_Linux_amd64.tar.gz && mv eksctl /usr/local/bin && echo ". <(eksctl completion bash)" >> /root/.bashrc

# kubectl install
RUN cd /tmp && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# krew install
RUN set -x; cd "$(mktemp -d)" && OS="$(uname | tr '[:upper:]' '[:lower:]')" && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && KREW="krew-${OS}_${ARCH}" && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && tar zxvf "${KREW}.tar.gz" && ./"${KREW}" install krew && echo "export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"" >> /root/.bashrc
RUN export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && kubectl krew install resource-capacity && kubectl krew install ctx && kubectl krew install ns && kubectl krew install konfig && kubectl krew install score

# helm install
RUN cd /tmp && wget https://get.helm.sh/helm-v3.10.2-linux-amd64.tar.gz && tar -zxvf helm-v3.10.2-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm && mkdir -p /etc/bash_completion.d && helm completion bash > /etc/bash_completion.d/helm

# k9s install
RUN cd /tmp && wget https://github.com/derailed/k9s/releases/download/v0.26.7/k9s_Linux_x86_64.tar.gz && tar -zxvf k9s_Linux_x86_64.tar.gz && mv k9s /usr/local/bin/k9s
