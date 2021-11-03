---
title: "Manual"
linkTitle: "Manual"
weight: 50
description: >
    Prerequisites necessary for manual deployment
---

This document describes manual deployment prerequisites. This deployment method is **not recommended**. For other options, see [here]({{< relref "." >}}).

If you would like to run the deployment on your PC without a container, this is a list of the tools required to complete the deployment. The exact versions of the tools used, where the version is important, can be found in the [Dockerfile](https://github.com/Azure/eu-digital-covid-certificates-reference-architecture/blob/main/.devcontainer/Dockerfile).

The following are needed for a deployment:

* [Git](https://git-scm.com/downloads)
* [Make](https://www.gnu.org/software/make/)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Azure CLI SSH extension](https://docs.microsoft.com/en-us/cli/azure/ssh)
* [Terraform](https://www.terraform.io/downloads.html)
* [jq](https://stedolan.github.io/jq/download/)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/)
* [Java JDK 11](https://docs.microsoft.com/en-us/java/openjdk/download)

Once the tooling is installed and the code has been checked out, please proceed to the deployment page of this docs.
