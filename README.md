# kook

Toolset for work with EKS - Kubernetes on AWS

## Usage

Just run with credentials mounted to the container:

```bash
# Ubuntu-based image
docker run -it -v ~/.aws/credentials:/root/.aws/credentials -v ~/.aws/config:/root/.aws/config -v ~/.kube/config:/root/.kube/config ncsystems/kook:ubuntu /bin/bash
```

or

```bash
# Alpine-based image
docker run -it -v ~/.aws/credentials:/root/.aws/credentials -v ~/.aws/config:/root/.aws/config -v ~/.kube/config:/root/.kube/config ncsystems/kook:alpine /bin/ash
```

Or you can make aliases for frequent usage:

```bash
alias kook-ubuntu=`docker run -it -v ~/.aws/credentials:/root/.aws/credentials -v ~/.aws/config:/root/.aws/config -v ~/.kube/config:/root/.kube/config ncsystems/kook:ubuntu /bin/bash`
alias kook-alpine=`docker run -it -v ~/.aws/credentials:/root/.aws/credentials -v ~/.aws/config:/root/.aws/config -v ~/.kube/config:/root/.kube/config ncsystems/kook:alpine /bin/ash`
```

## About

Contains:

* awscli and eksctl
* kubectl
* krew (kubectl plugin manager) with plugins resource-capacity, score, ctx, konfig
* helm with plugins diff, secrets
* k9s

There are ubuntu-based and alpine-based images:

* ncsystems/kook:ubuntu
* ncsystems/kook:alpine

## Build your own

In case you don't trust the public image (and that is understandable) you can build and use your own:

```
# Ubuntu-based
docker build -t kook:ubuntu . -f Dockerfile --no-cache
docker run -it -v ~/.aws/credentials:/root/.aws/credentials -v ~/.aws/config:/root/.aws/config -v ~/.kube/config:/root/.kube/config kook:ubuntu /bin/bash

# Alpine-based
docker build -t kook:local . -f Dockerfile.alpine --no-cache
docker run -it -v ~/.aws/credentials:/root/.aws/credentials -v ~/.aws/config:/root/.aws/config -v ~/.kube/config:/root/.kube/config kook:alpine /bin/ash
```