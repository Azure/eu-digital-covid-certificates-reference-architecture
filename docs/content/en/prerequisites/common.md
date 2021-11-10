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
* TODO: What do we do with TF State?

### DNS Domain Name / Zone resource in Azure

The reference architecture takes advantage of Azure DNS for create and allocate DNS host names to service APIs and web endpoints programmatically through code.

Please see the [following guide]({{< relref "azure-dns" >}}) for setting up a domainin in Azure DNS.

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

Read about [setting up Azure DNS]({{< relref "azure-dns.md" >}}) in the next section.

### Terraform State Managment

This reference architecture uses Terraform's state store to manage the infrastructure and configuration lifecycle.

This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

Ideally the state store should be stored and accessed remotely, but for simplicity for this blueprint Terraform's state store locally in files named `terraform.tfstate`.

#### Export Terraform State Store, Terraform Varable and Certs

Runing this command will generate a `export.zip` in the root on the project, while you can right click on and download if on Github Codespaces.

```bash
$ make state-export
```

#### Import Terraform State Store, Terraform Varable and Certs

Importing a zip file called `import.zip` in the root on the project.

```bash
$ make state-import
```

> __Calls to Action__
>
>Read about the [Azure DNS]({{< relref "azure-dns.md" >}}) in the next section.
