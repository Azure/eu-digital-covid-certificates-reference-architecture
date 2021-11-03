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
* DNS Domain Name / Zone resource in Azure:
  * See the [following guide]({{< relref "azure-dns" >}}) for setting up a domainin in Azure DNS
* TODO: What do we do with TF State?

### Required Azure Preview features

Please ensure that the following Azure Preview features listed in the table below are registered on the Azure subscription.

| Name                                                    | Documentation                                                                                                              | Name Space          | Feature Flag       | Description                                                                                                                                                                                             | Azure PowerShell Command                                                                            | Azure CLI Command                                                               |
| ------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Host-based encryption on Azure Kubernetes Service (AKS) | [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli) | "Microsoft.Compute" | "EncryptionAtHost" | The data stored on the VM host of your AKS agent nodes' VMs is encrypted at rest and flows encrypted to the Storage service. This means the temp disks are encrypted at rest with platform-managed keys | `Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute"` | `az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"` |

After applying all the feature registrations, please check that the registration state have fully registered, as it may take a few minutes, before deploying this reference architecture.

#### PowerShell

```PowerShell
 Get-AzProviderFeature -FeatureName "<Feature_Flag>" -ProviderNamespace "<NAME_SPACE>"
```

#### AZ CLI

```bash
az feature show --namespace "<NAME_SPACE>" --name "<Feature_Flag>"
```
