---
title: "Installation - Variables"
linkTitle: "Variables"
weight: 1
---

Gather the required variables:

## Dev

<!-- BEGIN_TF_DOCS_DEV -->
```ini

# OID of the Group to grant Administrator permissions. This is used to allow access to the deployed AKS cluster for deployments and troubleshooting
administrator_group_oid = ""

# List of network prefixes allowed to SSH to Jumpbox VM
jumpbox_ssh_source_address_prefixes = []

# Location Name
location = ""

# Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing
prefix = ""

# Subscription to deploy into
subscription_id = ""

# Tenant to deploy into
tenant_id = ""
```
<!-- END_TF_DOCS_DEV -->

## EU

<!-- BEGIN_TF_DOCS_EU -->
```ini

# OID of the Group to grant Administrator permissions
administrator_group_oid = ""

# Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not
enable_log_analytics_workspace = false

# Version Number of the Gateway
gateway_version = "1.1.3-44c8778-azure-0.0.1-5f09fbf"

# Generation number to be appended to certain resource names (e.g. Purge Protected KeyVault's). Changing this value can only be done during a fresh deployment.
generation = 1

# GitHub Container Registry Password
ghcr_password = ""

# GitHub Container Registry Username
ghcr_username = ""

# The RSA Key for the Jump Box, required for remote executing code over SSH
jump_box_identity_file = ""

# The Host address for the Jump Box, required for remote executing code over SSH
jump_box_identity_host = ""

# The User for the Jump Box to authenticate, required for remote executing code over SSH
jump_box_identity_user = ""

# Location Name
location = ""

# Enable the sending of Azure Log Workspace to Log Analytics Analytics Custer ID supplied
log_analytics_cluster_id = ""

# Parent DNS Zone Name
parent_dns_zone_name = ""

# Parent DNS Zone Resource Group Name
parent_dns_zone_rg_name = ""

# Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing
prefix = ""

# Subscription to deploy into
subscription_id = ""

# Tenant to deploy into
tenant_id = ""

# Tag of the Utility Image to import
utility_image_tag = "0.0.1-c5b4119"
```
<!-- END_TF_DOCS_EU -->

## IE

<!-- BEGIN_TF_DOCS_IE -->
```ini

# OID of the Group to grant Administrator permissions. This is used to allow access to the jumpboxes for deployments and troubleshooting
administrator_group_oid = ""

# Version Number of the Business Rules Service
businessrule_service_version = "1.1.2-b0be8f4-azure-0.0.1-1293959"

# Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not
enable_log_analytics_workspace = false

# Generation number to be appended to certain resource names (e.g. Purge Protected KeyVault's). Changing this value can only be done during a fresh deployment.
generation = 1

# GitHub Container Registry Password
ghcr_password = ""

# GitHub Container Registry Username
ghcr_username = ""

# Version Number of the Issuance Service
issuance_service_version = "1.0.5-7408b55-azure-0.0.1-1293959"

# Version Number of the Issuance Web
issuance_web_version = "1.1.2-45daa28-azure-0.0.1-1293959"

# The RSA Key for the Jump Box, required for remote executing code over SSH
jump_box_identity_file = ""

# The Host address for the Jump Box, required for remote executing code over SSH
jump_box_identity_host = ""

# The User for the Jump Box to authenticate, required for remote executing code over SSH
jump_box_identity_user = ""

# Location Name
location = ""

# Enable the sending of Azure Log Workspace to Log Analytics Analytics Custer ID supplied
log_analytics_cluster_id = ""

# version of the msal docker image to use
msal_proxy_version = "latest"

# Tag of the Nginx Image to import
nginx_image_tag = "1.21.1"

# Parent DNS Zone Name
parent_dns_zone_name = ""

# Parent DNS Zone Resource Group Name
parent_dns_zone_rg_name = ""

# Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing
prefix = ""

# Subscription to deploy into
subscription_id = ""

# Tenant to deploy into
tenant_id = ""

# Tag of the Utility Image to import
utility_image_tag = "0.0.1-c5b4119"

# Version Number of the Verifier Service
verifier_service_version = "1.0.4-5888cb7-azure-0.0.1-1293959"
```
<!-- END_TF_DOCS_IE -->