---
title: "Ireland Terraform Stack"
linkTitle: "Ireland Terraform Stack"
weight: 30
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
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 1.6.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.71.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_base_infra"></a> [base\_infra](#module\_base\_infra) | ../terraform-modules/base-infrastructure | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application.msal_authentication](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.msal_authentication](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.msal_authentication](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_key_vault_certificate.dsc_key_store_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.tls_key_store_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.upload_key_store_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.dsc_key_store_alias](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.msal_authentication_client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.tls_key_store_alias](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.tls_trust_store_content](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.tls_trust_store_password](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.trustanchor_alias](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.trustanchor_content](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.trustanchor_password](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.upload_key_store_alias](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_mysql_database.businessrule_service_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/mysql_database) | resource |
| [azurerm_mysql_database.issuance_service_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/mysql_database) | resource |
| [azurerm_mysql_database.verifier_service_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/mysql_database) | resource |
| [azurerm_role_assignment.dgca_businessrule_service_kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.dgca_issuance_service_kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.dgca_issuance_service_public_kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.dgca_verifier_service_kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.msal_identity_kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.dgca_businessrule_service_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.dgca_issuance_service_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.dgca_issuance_service_public_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.dgca_issuance_web_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.dgca_verifier_service_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.msal_authentication](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [helm_release.dgca_businessrule_service](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.dgca_issuance_service](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.dgca_issuance_service_public](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.dgca_issuance_web](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.dgca_verifier_service](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.msal_authentication](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.dgca_businessrule_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.dgca_issuance_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.dgca_issuance_service_public](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.dgca_issuance_web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.dgca_verifier_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.upsert_rules](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_uuid.web_auth_oauth2_scope](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [terraform_remote_state.dev](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.eu](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_password"></a> [acr\_password](#input\_acr\_password) | ACR Password | `string` | n/a | yes |
| <a name="input_acr_username"></a> [acr\_username](#input\_acr\_username) | ACR Username | `string` | n/a | yes |
| <a name="input_administrator_group_oid"></a> [administrator\_group\_oid](#input\_administrator\_group\_oid) | OID of the Group to grant Administrator permissions. This is used to allow access to the jumpboxes for deployments and troubleshooting | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location Name | `string` | n/a | yes |
| <a name="input_parent_dns_zone_name"></a> [parent\_dns\_zone\_name](#input\_parent\_dns\_zone\_name) | Parent DNS Zone Name | `string` | n/a | yes |
| <a name="input_parent_dns_zone_rg_name"></a> [parent\_dns\_zone\_rg\_name](#input\_parent\_dns\_zone\_rg\_name) | Parent DNS Zone Resource Group Name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription to deploy into | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant to deploy into | `string` | n/a | yes |
| <a name="input_businessrule_service_version"></a> [businessrule\_service\_version](#input\_businessrule\_service\_version) | Version Number of the Business Rules Service | `string` | `"93"` | no |
| <a name="input_issuance_service_version"></a> [issuance\_service\_version](#input\_issuance\_service\_version) | Version Number of the Issuance Service | `string` | `"94"` | no |
| <a name="input_issuance_web_version"></a> [issuance\_web\_version](#input\_issuance\_web\_version) | Version Number of the Issuance Web | `string` | `"90"` | no |
| <a name="input_msal_proxy_version"></a> [msal\_proxy\_version](#input\_msal\_proxy\_version) | version of the msal docker image to use | `string` | `"0.0.1"` | no |
| <a name="input_nginx_image_tag"></a> [nginx\_image\_tag](#input\_nginx\_image\_tag) | Tag of the Nginx Image to import | `string` | `"1.21.1"` | no |
| <a name="input_utility_image_tag"></a> [utility\_image\_tag](#input\_utility\_image\_tag) | Tag of the Utility Image to import | `string` | `"3"` | no |
| <a name="input_verifier_service_version"></a> [verifier\_service\_version](#input\_verifier\_service\_version) | Version Number of the Verifier Service | `string` | `"95"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_issuance_web_address"></a> [issuance\_web\_address](#output\_issuance\_web\_address) | The web address where the issueance website can be accessed |
<!-- END_TF_DOCS -->
