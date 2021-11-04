---
title: "Deployment"
linkTitle: "Deployment"
weight: 50
description: >
    Deploy the EU Digital Green Certificate Reference Architecture
---

## Set Variables

Below is a starter set of variables needed to deploy a simple example of the stack.

A full set of options is documented in the [Terraform]({{< relref "/terraform.md" >}}) section.

We used a combined `terraform.tfvars` for all three steps, so combine any extra options needed into this single file.

Create a `terraform.tfvars` at the root of the repo that contains:

```terraform
prefix                              = "<prefix>"
location                            = "northeurope"
subscription_id                     = "<id>"
tenant_id                           = "<id>"
parent_dns_zone_name                = "contoso.com"
parent_dns_zone_rg_name             = "<id>"
administrator_group_oid             = "<id>"
jumpbox_ssh_source_address_prefixes = []
ghcr_username                       = "<GH Username>"
ghcr_password                       = "<GH Password / Token>"
```


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Resource Name Prefix. Should be less than 6 chars. This is used to make sure some resource names are globally unique for some azure resources that require unique names (like Key Vault and Azure Container Registries) | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Location Name | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription to deploy into | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant to deploy into | `string` | n/a | yes |
| <a name="input_parent_dns_zone_name"></a> [parent\_dns\_zone\_name](#input\_parent\_dns\_zone\_name) | Parent DNS Zone Name | `string` | n/a | yes |
| <a name="input_parent_dns_zone_rg_name"></a> [parent\_dns\_zone\_rg\_name](#input\_parent\_dns\_zone\_rg\_name) | Parent DNS Zone Resource Group Name | `string` | n/a | yes |
| <a name="input_administrator_group_oid"></a> [administrator\_group\_oid](#input\_administrator\_group\_oid) | OID of the Group to grant Administrator permissions. This is used to allow access to the deployed AKS cluster for deployments and troubleshooting | `string` | n/a | yes |
| <a name="input_jumpbox_ssh_source_address_prefixes"></a> [jumpbox\_ssh\_source\_address\_prefixes](#input\_jumpbox\_ssh\_source\_address\_prefixes) | List of network prefixes allowed to SSH to Jumpbox VM | `list(string)` | `[]` | no |
| <a name="input_ghcr_password"></a> [ghcr\_password](#input\_ghcr\_password) | GitHub Container Registry Password | `string` | n/a | yes |
| <a name="input_ghcr_username"></a> [ghcr\_username](#input\_ghcr\_username) | GitHub Container Registry Username | `string` | n/a | yes |

## Deployment

We offer two ways of doing the install, and all in one deployment, or a step by step, which can help you understand the difference
resources, groups and terraform stacks.
### All In One Deployment

Once the variables file has been created, the process of creating the infrastructure and deploying the application has been automated though terraform and scripts. Before initialing the deployment, Azure cli (az) must be logged in, you can log in by running `az login`.
After logged, the process can be started by running `make` on the base directory of the project. This will create the required certificates and start the terraform deployment of the different components described in the step by step process.

```bash
➜ /workspaces/eu-digital-covid-certificates-reference-architecture (main) $ make
```

### Step by Step Deployment

This section describes how to apply each step manually instead of getting invoked by the main `make`.

#### Step by Step - Terraform workspaces

Deployment is done via terraform, which supports workspaces for isolation between different deployments of the same infrastructure. In this case, we use the variable defined in `prefix` to create different terraform workspaces, so multiple users can perform a deployment in the same subscription. Running `make workspace` will go to the different terraform stacks and adjust the namespace.

```bash
➜ /workspaces/eu-digital-covid-certificates-reference-architecture (main) $ make workspace
```

#### Step by Step - Certificates

As describes in `certificates` doc section, project relies on certificates to ensure security as well as the green digital certificate itself.
The process of generating the certificates has been automated in an [script](scripts/generate-certs.sh), it can be invoked with the required arguments/variables by `make certs` command.

```bash
➜ /workspaces/eu-digital-covid-certificates-reference-architecture (main) $ make certs
```

#### Step by Step - Jumpboxes

For security, none of the services used in this deployment, uses public endpoints (except of course the load balances), this prevents any public IP reaching the Databases or Key vault. This means that before connecting Kubernetes cluster (AKS) to perform deployments, we need to connect to jumphosts that have private connectivity to the services.

This step is performed by moving to the `eudgc-dev` and executing `make`. The first part of this make target will create the infrastructure for the jumpboxes using terraform, once the VMs are ready, it will create ssh configuration files (in `eudgc-dev/jumpbox-ssh-configs` folder) to facilitate the access to it as well as establishing the required tunnels to reach AKS clusters.

```bash
➜ /workspaces/eu-digital-covid-certificates-reference-architecture (main) $ cd eudcc-dev/
➜ /workspaces/eu-digital-covid-certificates-reference-architecture/eudcc-dev (main) $ make
```

#### Step by Step - EU Infrastructure

Each country service, relies on the "central" european gateway. The folder `eudgc-eu` contains the folder with the infrastructure and deployment of the gateway. The default make target (all), will first establish the required ssh tunnels to start the proxy in the VNET where the deployment will be made, enabling the deployment of the application after the AKS cluster is up and running.

```bash
➜ /workspaces/eu-digital-covid-certificates-reference-architecture/eudcc-dev (main) $ cd ../
➜ /workspaces/eu-digital-covid-certificates-reference-architecture (main) $ cd eudcc-eu/
➜ /workspaces/eu-digital-covid-certificates-reference-architecture/eudcc-eu (main) $ make
```

#### Step by Step - IE Infrastructure

The main applications of this deployment are the validation and rules services, that are deployed by each country and the mobile apps will contact to. Those services, as well as the EU are deployed into a kubernetes (AKS) cluster, applying the same security principles, only the HTTPS services being exposed. All the infrastructure and deployment is done via terraform, in the folder `eudgc-ie`.

```bash
➜ /workspaces/eu-digital-covid-certificates-reference-architecture/eudcc-eu (main) $ cd ../
➜ /workspaces/eu-digital-covid-certificates-reference-architecture (main) $ cd eudcc-ie/
➜ /workspaces/eu-digital-covid-certificates-reference-architecture/eudcc-ie (main) $ make
```

Read about [validation]({{< relref "validation.md" >}}) in the next section.
