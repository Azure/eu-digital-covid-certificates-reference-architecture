---
title: "Deployment"
linkTitle: "Deployment"
weight: 50
description: >
    Deploy the EU Digital Green Certificate Reference Architecture
---

## Set Variables

Create a `terraform.tfvars` at the root of the repo that contains:

```
prefix                              = "<prefix>"
subscription_id                     = "<id>"
tenant_id                           = "<id>"
jumpbox_ssh_source_address_prefixes = []
acr_username                        = "apecoeacr"
acr_password                        = "<ADMIN PW FETCHED FROM APECOE ACR in DEV1 SUB>"
administrator_group_oid             = "<id>"
location                            = "northeurope"
parent_dns_zone_name                = "dns name"
parent_dns_zone_rg_name             = "<id>"
enable_log_analytics_workspace      = false
enable_log_analytics_cluster        = false

```
Where:
* `prefix` is set as a unique identifier (please avoid spaces or special characters). This is used to create names and identifiers of the different resources, so multiple deployments can be done on the same subscription.
* `jumpbox_ssh_source_address_prefixes` is set as the public IP address(es) from which you are connecting to Azure (run `curl icanhazip.com` to find your public IP).
* `tenant_id` is the id of the tenant owning the subcription where the deployment will be made.
* `subscription_id` the id of the subcription where the deployment wil be made.
* `jumpbox_ssh_source_address_prefixes` Additional allowed ip / network prefixes allowed to connect to the jump boxes. We will automatically add the external IP address of the machine running the deployment. These should be in a comma separated list, using network prefix format like : `["10.0.0.0/8","192.168.100.25/32"]`
* `acr_username` the username of the ACR (Azure containter registry) where the images will be pulled from.
* `acr_password` password for the ACR.
* `administrator_group_oid` Object id of the AAD group that will get adminstrator access.
* `location` The az region (short name) where the deployment will be made.
* `parent_dns_zone_name` The name of the domain created for the deployment in the prerequisites section.
* `parent_dns_zone_rg_name` The resource group where the DNS zone has been created.
* `enable_log_analytics_workspace` Enable Azure Log Analytics Workspace, disabled by default.
* `enable_log_analytics_cluster` Enable Azure Log Analytics cluster, disabled by default. `enable_log_analytics_workspace`  is also required if you wish Log Analytics cluster to be enabled. Also advised to looking into your Azure Subcription's Qoutas before enabling.


## All In One Deployment
Once the variables file has been created, the process of creating the infrastructure and deploying the application has been automated though terraform and scripts. Before initialing the deployment, Azure cli (az) must be logged in, you can log in by running `az login`.
After logged, the process can be started by running `make` on the base directory of the project. This will create the required certificates and start the terraform deployment of the different components described in the step by step process.

## Step by Step Deployment
This section describes how to apply each step manually instead of gettin invoked by the main `make`.

### Step by Step - Terraform workspaces
Deployment is done via terraform, which supports workspaces for isolation between different deployments of the same infrastructure. In this case, we use the variable defined in `prefix` to create different terraform workspaces, so multiple users can perform a deployment in the same subscription. Running `make workspace` will go to the different terraform stacks and adjust the namespace.

### Step by Step - Tools
Some dgc specific signatures are required for the certificate generation in the next step, tools target in main Makefile, downloads the gdc-cli binary (jar) in the tools folder. There's also a Makefile in the tools folder that can be invoked directly.

### Step by Step - Certificates
As describes in `certificates` doc section, project relies on certificates to ensure security as well as the green digitcal certificate itself.
The process of generating the certificates has been automated in an [script](scripts/generate-certs.sh), it can be invoked with the required arguments/variables by `make certs` command.

### Step by Step - Jumpboxes
For security, none of the services used in this deployment, uses public endpoints (except of course the load balances), this prevents anyy public IP reaching the Databases or Key vault. This means that before connecting Kubernetes cluster (AKS) to perform deployments, we need to connect to jumphosts that have private connectivity to the services.

This step is performed by moving to the `eudgc-dev` and executing `make`. The first part of this make target will create the infrastructure for the jumpboxes using terraform, once the VMs are ready, it will create ssh configuration files (in `eudgc-dev/jumpbox-ssh-configs` folder) to facilitate the access to it as well as stablishing the required tunnels to reach AKS clusters.

### Step by Step - EU Infrastructure
Each country service, relies on the "central" european gategway. The folder `eudgc-eu` contains the folder with the infrastructre and deployment of the gateway. The default make target (all), will first stanlish the required ssh tunnels to start the proxy in the VNET where the deployment will be made, enabling the deployment of the application after the AKS cluster is up and running.

### Step by Step - IE Infrastructure
The main applications of this deployment are the validation and rules services, that are deployed by each country and the mobile apps will contact to. Those services, as well as the EU are deployed into a kubernetes (AKS) cluster, applying the same security principles, only the HTTPS services being exposed. All the infrastructre and deployment is done via terraform, in the folder `eudgc-ie`.

