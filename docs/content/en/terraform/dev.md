---
title: "Development Terraform Stack"
linkTitle: "Development Terraform Stack"
weight: 10
description: >
    Docs for the development deployment
include_toc: false
---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =2.71.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | =1.11.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eu_dev_jumpbox"></a> [eu\_dev\_jumpbox](#module\_eu\_dev\_jumpbox) | ../terraform-modules/dev-jumpbox | n/a |
| <a name="module_ie_dev_jumpbox"></a> [ie\_dev\_jumpbox](#module\_ie\_dev\_jumpbox) | ../terraform-modules/dev-jumpbox | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_group_oid"></a> [administrator\_group\_oid](#input\_administrator\_group\_oid) | OID of the Group to grant Administrator permissions. This is used to allow access to the deployed AKS cluster for deployments and troubleshooting | `string` | n/a | yes |
| <a name="input_jumpbox_ssh_source_address_prefixes"></a> [jumpbox\_ssh\_source\_address\_prefixes](#input\_jumpbox\_ssh\_source\_address\_prefixes) | List of network prefixes allowed to SSH to Jumpbox VM | `list(string)` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription to deploy into | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant to deploy into | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location Name | `string` | `"northeurope"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eu_rg_name"></a> [eu\_rg\_name](#output\_eu\_rg\_name) | n/a |
| <a name="output_eu_vnet_id"></a> [eu\_vnet\_id](#output\_eu\_vnet\_id) | n/a |
| <a name="output_eu_vnet_name"></a> [eu\_vnet\_name](#output\_eu\_vnet\_name) | n/a |
| <a name="output_ie_rg_name"></a> [ie\_rg\_name](#output\_ie\_rg\_name) | n/a |
| <a name="output_ie_vnet_id"></a> [ie\_vnet\_id](#output\_ie\_vnet\_id) | n/a |
| <a name="output_ie_vnet_name"></a> [ie\_vnet\_name](#output\_ie\_vnet\_name) | n/a |
<!-- END_TF_DOCS -->
