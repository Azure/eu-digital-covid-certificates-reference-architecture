---
title: "Prerequisites"
linkTitle: "Prerequisites"
weight: 10
description: >
    Description of the necessary prerequisites
---

### Azure Prerequisites
* An active Azure account, with a subscription available for us.
* Any preview features needing to be registered?

TODO...
* DNS Domain Name / Zone resource in Azure?
* TF State?


## Deployment with devcontainer
This repository includes configuration for a development container, allowing for repeatable and reliable usage in an VS Code DevContainer or using GitHub Codespaces.

This document describes it's use within a VS Code DevContainer.

### Download and install Docker
[Docker](https://www.docker.com/products/docker-desktop) (Versions vary depending on the platform)

### Download and install VS Code
Visual studio code is the Microsoft free IDE, it can be downloaded here: [Visual Studio code](https://code.visualstudio.com/)

### Install required VS Code extensions
The devlopment in containers ("Remote - Containers"), it is not installed by default with VS code and it is an addon, it can be installed through the [web link](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

### Clone the respository and open in a DevContainer
Once the repository has been cloned, VS code will promt to open the repository in a container, if this would not happen, it can be triggered by the command palete (CMD+Shift+p) and selecting the command 'Reopen in container'. The first time, vs code automatically will build and run the container locally, attaching the IDE UI to it.

Once container has been opened, please go to the deployment page of the docs.

## Manual Deployment - Prerequisites (Not Recommended)
If you would like to run the deployment in your PC without a container, this here is a compresive list of the tools required to complete the deployment. The versions of the tools used, can be found in the [Dockerfile](.devcontainer/Dockerfile).

The following are needed for a deployment:

### Install required VS Code extensions
The devlopment in containers ("Remote - Containers"), it is not installed by default with VS code and it is an addon, it can be installed through the [web link](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

### Clone the respository and open in a DevContainer
Once the repository has been cloned, VS code will promt to open the repository in a container, if this would not happen, it can be triggered by the command palete (CMD+Shift+p) and selecting the command 'Reopen in container'. The first time, vs code automatically will build and run the container locally, attaching the IDE UI to it.

Once container has been opened, please go to the deployment page of the docs.

## Manual Deployment Prerequisites (Not Recommended)
If you would like to run the deployment in your PC without a container, this here is a compresive list of the tools required to complete the deployment. The versions of the tools used, can be found in the [Dockerfile](.devcontainer/Dockerfile).

* Bash
* [Git](https://git-scm.com/downloads)
* [Terraform](https://www.terraform.io/downloads.html)
* [Az CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* Az ssh extension (run `az extension add --name ssh`)
* [Jq](https://stedolan.github.io/jq/download/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Make](https://www.gnu.org/software/make/)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/)
* [Java JDK 11](https://docs.microsoft.com/en-us/java/openjdk/download)
* If using a AZ CLI version earlier than  2.25, please upgrade to the latest, or install `requests[socks]` in the az cli folders:
  - Ubuntu: `sudo /opt/az/bin/python3 /opt/az/bin/pip3 install requests[socks]==2.25.1 --target=/opt/az/lib/python3.6/site-packages/`
  - OSX: `pip3 install 'requests[socks]' --prefix /usr/local/Cellar/azure-cli/2.26.1/libexec --ignore-installed` (you may need to update the version number as the cli updates)

Once the tooling is installed and the code has been checked out, please proceed to the deployment page of this docs.
