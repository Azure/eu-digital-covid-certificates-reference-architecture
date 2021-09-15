---
title: "EU Terraform Stack"
linkTitle: "EU Terraform Stack"
weight: 20
description: >
    Docs for the EU Gateway deployment terraform
---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =2.71.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | =1.11.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.71.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_base_infra"></a> [base\_infra](#module\_base\_infra) | ../terraform-modules/base-infrastructure | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_certificate.trustanchor_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.trustanchor_alias](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_mysql_database.mysql_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/mysql_database) | resource |
| [azurerm_role_assignment.dgc_gateway_identity_kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.dgc_gateway_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [helm_release.dgc_gateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.dgc_gateway](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [terraform_remote_state.dev](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_password"></a> [acr\_password](#input\_acr\_password) | ACR Password | `string` | n/a | yes |
| <a name="input_acr_username"></a> [acr\_username](#input\_acr\_username) | ACR Username | `string` | n/a | yes |
| <a name="input_administrator_group_oid"></a> [administrator\_group\_oid](#input\_administrator\_group\_oid) | OID of the Group to grant Administrator permissions | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location Name | `string` | n/a | yes |
| <a name="input_parent_dns_zone_name"></a> [parent\_dns\_zone\_name](#input\_parent\_dns\_zone\_name) | Parent DNS Zone Name | `string` | n/a | yes |
| <a name="input_parent_dns_zone_rg_name"></a> [parent\_dns\_zone\_rg\_name](#input\_parent\_dns\_zone\_rg\_name) | Parent DNS Zone Resource Group Name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription to deploy into | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant to deploy into | `string` | n/a | yes |
| <a name="input_gateway_version"></a> [gateway\_version](#input\_gateway\_version) | Version Number of the Gateway | `string` | `"79"` | no |
| <a name="input_utility_image_tag"></a> [utility\_image\_tag](#input\_utility\_image\_tag) | Tag of the Utility Image to import | `string` | `"3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dgc_gateway_fqdn"></a> [dgc\_gateway\_fqdn](#output\_dgc\_gateway\_fqdn) | The fqdn for the EU DGC Gateway used by the per member country deployments |
<!-- END_TF_DOCS -->
