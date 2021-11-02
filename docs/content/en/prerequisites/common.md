---
title: "Common"
linkTitle: "Common"
weight: 10
description: >
    Common prerequisites necessary for all deployment methods
---

## Azure Prerequisites

* An active Azure account
* A subscription available for deployment into, where you have `Owner` privileges
* Ensure by checking the following table [below]({{< relref "common#required-azure-preview-features" >}}) Azure Preview features are registered on this subscription.
* DNS Domain Name / Zone resource in Azure
  * See the [following guide]({{< relref "azure-dns" >}}) for setting up a domainin in Azure DNS
* TODO: What do we do with TF State?

### Required Azure Preview features

| Name                                                    | Name Space                   | Description                                                                                                                                                                                             | Azure CLI Command                                                                              |
| ------------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Host-based encryption on Azure Kubernetes Service (AKS) | "Microsoft.Compute"          | The data stored on the VM host of your AKS agent nodes' VMs is encrypted at rest and flows encrypted to the Storage service. This means the temp disks are encrypted at rest with platform-managed keys | `az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"`                |
