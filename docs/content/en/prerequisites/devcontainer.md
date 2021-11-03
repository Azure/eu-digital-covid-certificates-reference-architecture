---
title: "VS Code DevContainer"
linkTitle: "VS Code DevContainer"
weight: 30
description: >
    Prerequisites necessary for deployment using a VS Code DevContainer
---

This repository includes configuration for a DevContainer, allowing for repeatable and reliable usage in VS Code or using [GitHub Codespaces]({{< relref "github-codespaces" >}}).

This document describes it's use within a VS Code. For other options, see [here]({{< relref "." >}}).

### Download and install Docker

Docker is required for running the DevContainer, please follow the Docker [installation guidance](https://docs.docker.com/get-docker/) for your platform.

### Download and install VS Code

Visual Studio Code is Microsoft's free IDE, it can be downloaded here: [Visual Studio code](https://code.visualstudio.com/).

### Install required VS Code extensions

The "Remote - Containers" extension is required to use a DevContainer, it is not installed by default. Please follow the [installation instructions](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for installing this extension.

### Clone the respository and open in a DevContainer

Once the repository has been cloned, VS code will prompt to open the repository in a container, if this would not happen, it can be triggered by the command palete (CMD+Shift+p) and selecting the command 'Reopen in container'. The first time, vs code automatically will build and run the container locally, attaching the IDE UI to it.

Once container has been opened, please go to the deployment page of the docs.

### Open a Terminal within DevContainer

To open a Terminal within the DevContainer, press `Ctrl+Shift+P` (`Cmd+Shift+P` on OSX), and begin to type "Terminal". Choose the "Terminal: Create New Terminal" option and press return.
