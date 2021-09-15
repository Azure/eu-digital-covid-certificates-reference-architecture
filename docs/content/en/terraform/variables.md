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

# ACR Password
acr_password = ""

# ACR Username
acr_username = ""

# OID of the Group to grant Administrator permissions
administrator_group_oid = ""

# Enable the creation of Azure Log Analytics Custer linked to Log Analytics Workspace
enable_log_analytics_cluster = false

# Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not
enable_log_analytics_workspace = false

# Version Number of the Gateway
gateway_version = "79"

# Location Name
location = ""

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
utility_image_tag = "3"
```
<!-- END_TF_DOCS_EU -->

## IE

<!-- BEGIN_TF_DOCS_IE -->
```ini

# ACR Password
acr_password = ""

# ACR Username
acr_username = ""

# OID of the Group to grant Administrator permissions. This is used to allow access to the jumpboxes for deployments and troubleshooting
administrator_group_oid = ""

# Version Number of the Business Rules Service
businessrule_service_version = "93"

# Enable the creation of Azure Log Analytics Custer linked to Log Analytics Workspace
enable_log_analytics_cluster = false

# Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not
enable_log_analytics_workspace = false

# Version Number of the Issuance Service
issuance_service_version = "94"

# Version Number of the Issuance Web
issuance_web_version = "90"

# Location Name
location = ""

# version of the msal docker image to use
msal_proxy_version = "0.0.1"

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
utility_image_tag = "3"

# Version Number of the Verifier Service
verifier_service_version = "95"
```
<!-- END_TF_DOCS_IE -->