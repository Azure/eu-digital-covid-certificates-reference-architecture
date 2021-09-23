---
title: "Base Infrastructure Terraform Module"
linkTitle: "Base Infrastructure Module"
weight: 10
---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =2.71.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | =2.2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | =1.11.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | =2.4.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | =3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | =3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =2.71.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | =2.2.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | =1.11.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | =2.4.1 |
| <a name="provider_null"></a> [null](#provider\_null) | =3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | =3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/container_registry) | resource |
| [azurerm_disk_encryption_set.aks_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/disk_encryption_set) | resource |
| [azurerm_dns_ns_record.dns_delegation](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.dns](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/dns_zone) | resource |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.aks_encryption_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_key.mysql_encryption_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.mysql_pw](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/key_vault_secret) | resource |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_log_analytics_linked_service.log_analytics_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_linked_service) | resource |
| [azurerm_log_analytics_solution.anti_malware](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.azure_activity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.change_tracking](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.container_insights](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.key_vault_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.network_monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.security_insights](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.service_map](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.sql_assessment_plus](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_solution.updates](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.acr_diagnostic_logs](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.keyvault_diagnostic_logs](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.mysql_diagnostic_logs](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_mysql_active_directory_administrator.mysql_aadadmin](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/mysql_active_directory_administrator) | resource |
| [azurerm_mysql_server.mysql](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/mysql_server) | resource |
| [azurerm_mysql_server_key.mysql_encryption_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/mysql_server_key) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.haproxy_ingress_allow_http](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.haproxy_ingress_allow_https](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_zone.private_dns_zone_acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.private_dns_zone_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.private_dns_zone_keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.private_dns_zone_mysql](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.private_dns_zone_postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_acr_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_acr_link_dev](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_aks_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_aks_link_dev](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_keyvault_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_keyvault_link_dev](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_mysql_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_mysql_link_dev](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_postgresql_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_postgresql_link_dev](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.acr_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.keyvault_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.mysql_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.haproxy_ingress_pip](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group_policy_assignment.aks_acr_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.aks_baseline_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_role_assignment.aks_acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_identity_dns_contributer](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_managed_rg_mio](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_managed_rg_vmc](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_mio](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_identity_dns_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.keyvault_admin_group_ra](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.mysql_kv_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.aks_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.external_dns_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.mysql_aadadmin_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.from-dev](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.to-dev](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/virtual_network_peering) | resource |
| [helm_release.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.csi_secrets_store_provider](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.haproxy_ingress](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [kubectl_manifest.cert_manager_clusterissuer_letsencrypt](https://registry.terraform.io/providers/gavinbunney/kubectl/1.11.2/docs/resources/manifest) | resource |
| [kubectl_manifest.external_dns_azure_identity](https://registry.terraform.io/providers/gavinbunney/kubectl/1.11.2/docs/resources/manifest) | resource |
| [kubectl_manifest.external_dns_azure_identity_binding](https://registry.terraform.io/providers/gavinbunney/kubectl/1.11.2/docs/resources/manifest) | resource |
| [kubernetes_namespace.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.haproxy_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [null_resource.aks_delay_before_consent](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [null_resource.import-image](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [null_resource.keyvault_admin_group_ra_delay_before_consent](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [null_resource.keyvault_private_endpoint_delay_before_consent](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [null_resource.mysql_delay_before_consent](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [random_password.mysql_pw](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.aks_managed_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_group_oid"></a> [administrator\_group\_oid](#input\_administrator\_group\_oid) | OID of the Group to grant Administrator permissions | `string` | n/a | yes |
| <a name="input_dev_vnet_id"></a> [dev\_vnet\_id](#input\_dev\_vnet\_id) | Dev VNet ID | `string` | n/a | yes |
| <a name="input_dev_vnet_name"></a> [dev\_vnet\_name](#input\_dev\_vnet\_name) | Dev VNet Name | `string` | n/a | yes |
| <a name="input_dev_vnet_rg_name"></a> [dev\_vnet\_rg\_name](#input\_dev\_vnet\_rg\_name) | Dev VNet RG Name | `string` | n/a | yes |
| <a name="input_jump_box_identity_file"></a> [jump\_box\_identity\_file](#input\_jump\_box\_identity\_file) | The RSA Key for the Jump Box, required for remote executing code over SSH | `string` | n/a | yes |
| <a name="input_jump_box_identity_host"></a> [jump\_box\_identity\_host](#input\_jump\_box\_identity\_host) | The Host address for the Jump Box, required for remote executing code over SSH | `string` | n/a | yes |
| <a name="input_jump_box_identity_user"></a> [jump\_box\_identity\_user](#input\_jump\_box\_identity\_user) | The User for the Jump Box to authenticate, required for remote executing code over SSH | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location Name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Environment Name | `string` | n/a | yes |
| <a name="input_parent_dns_zone_name"></a> [parent\_dns\_zone\_name](#input\_parent\_dns\_zone\_name) | Parent DNS Zone Name | `string` | n/a | yes |
| <a name="input_parent_dns_zone_rg_name"></a> [parent\_dns\_zone\_rg\_name](#input\_parent\_dns\_zone\_rg\_name) | Parent DNS Zone Resource Group Name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix | `string` | n/a | yes |
| <a name="input_aad_pod_identity_chart_version"></a> [aad\_pod\_identity\_chart\_version](#input\_aad\_pod\_identity\_chart\_version) | n/a | `string` | `"4.1.1"` | no |
| <a name="input_aad_pod_identity_image_tag"></a> [aad\_pod\_identity\_image\_tag](#input\_aad\_pod\_identity\_image\_tag) | n/a | `string` | `"v1.8.0"` | no |
| <a name="input_aad_pod_identity_immutable_uamis"></a> [aad\_pod\_identity\_immutable\_uamis](#input\_aad\_pod\_identity\_immutable\_uamis) | A list of immutable UAMI clien IDs for AAD Pod Identity. These IDs, once added to a node, will not be removed | `list(any)` | `[]` | no |
| <a name="input_acr_imports"></a> [acr\_imports](#input\_acr\_imports) | Map of ACR Imports to perform | `map(any)` | `{}` | no |
| <a name="input_azure_key_vault_provider_image_tag"></a> [azure\_key\_vault\_provider\_image\_tag](#input\_azure\_key\_vault\_provider\_image\_tag) | n/a | `string` | `"v0.1.0"` | no |
| <a name="input_cert_manager_chart_version"></a> [cert\_manager\_chart\_version](#input\_cert\_manager\_chart\_version) | n/a | `string` | `"1.4.0"` | no |
| <a name="input_cert_manager_image_tag"></a> [cert\_manager\_image\_tag](#input\_cert\_manager\_image\_tag) | n/a | `string` | `"v1.4.0"` | no |
| <a name="input_csi_node_driver_registrar_image_tag"></a> [csi\_node\_driver\_registrar\_image\_tag](#input\_csi\_node\_driver\_registrar\_image\_tag) | n/a | `string` | `"v2.2.0"` | no |
| <a name="input_csi_secrets_store_provider_azure_chart_version"></a> [csi\_secrets\_store\_provider\_azure\_chart\_version](#input\_csi\_secrets\_store\_provider\_azure\_chart\_version) | n/a | `string` | `"0.1.0"` | no |
| <a name="input_enable_log_analytics_workspace"></a> [enable\_log\_analytics\_workspace](#input\_enable\_log\_analytics\_workspace) | Enable the creation of azurerm\_log\_analytics\_workspace and azurerm\_log\_analytics\_solution or not | `bool` | `false` | no |
| <a name="input_external_dns_chart_version"></a> [external\_dns\_chart\_version](#input\_external\_dns\_chart\_version) | n/a | `string` | `"5.1.3"` | no |
| <a name="input_external_dns_image_tag"></a> [external\_dns\_image\_tag](#input\_external\_dns\_image\_tag) | n/a | `string` | `"0.8.0-debian-10-r26"` | no |
| <a name="input_haproxy_ingress_chart_version"></a> [haproxy\_ingress\_chart\_version](#input\_haproxy\_ingress\_chart\_version) | n/a | `string` | `"v0.13.0-beta.2"` | no |
| <a name="input_haproxy_ingress_image_tag"></a> [haproxy\_ingress\_image\_tag](#input\_haproxy\_ingress\_image\_tag) | n/a | `string` | `"v0.13.0-beta.2"` | no |
| <a name="input_kube_syslog_sidecar_image_digest"></a> [kube\_syslog\_sidecar\_image\_digest](#input\_kube\_syslog\_sidecar\_image\_digest) | n/a | `string` | `"sha256:f948c128ad982b3676269542da1d9e4339f5553a9fc6831b02edf21a667620d9"` | no |
| <a name="input_kube_syslog_sidecar_image_tag"></a> [kube\_syslog\_sidecar\_image\_tag](#input\_kube\_syslog\_sidecar\_image\_tag) | n/a | `string` | `"v0.0.1-f948c12"` | no |
| <a name="input_livenessprobe_csi_driver_image_tag"></a> [livenessprobe\_csi\_driver\_image\_tag](#input\_livenessprobe\_csi\_driver\_image\_tag) | n/a | `string` | `"v2.3.0"` | no |
| <a name="input_log_analytics_cluster_id"></a> [log\_analytics\_cluster\_id](#input\_log\_analytics\_cluster\_id) | Enable the sending of Azure Log Workspace to Log Analytics Analytics Custer ID supplied | `string` | `null` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018 | `string` | `"PerGB2018"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | The retention period for the logs in days | `number` | `30` | no |
| <a name="input_secrets_store_csi_driver_image_tag"></a> [secrets\_store\_csi\_driver\_image\_tag](#input\_secrets\_store\_csi\_driver\_image\_tag) | n/a | `string` | `"v0.1.0"` | no |
| <a name="input_secrets_store_driver_crds_image_tag"></a> [secrets\_store\_driver\_crds\_image\_tag](#input\_secrets\_store\_driver\_crds\_image\_tag) | n/a | `string` | `"v0.1.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | n/a |
| <a name="output_aks_client_certificate"></a> [aks\_client\_certificate](#output\_aks\_client\_certificate) | n/a |
| <a name="output_aks_client_key"></a> [aks\_client\_key](#output\_aks\_client\_key) | n/a |
| <a name="output_aks_cluster_ca_certificate"></a> [aks\_cluster\_ca\_certificate](#output\_aks\_cluster\_ca\_certificate) | n/a |
| <a name="output_aks_password"></a> [aks\_password](#output\_aks\_password) | n/a |
| <a name="output_aks_private_fqdn"></a> [aks\_private\_fqdn](#output\_aks\_private\_fqdn) | n/a |
| <a name="output_aks_username"></a> [aks\_username](#output\_aks\_username) | n/a |
| <a name="output_dns_zone_name"></a> [dns\_zone\_name](#output\_dns\_zone\_name) | n/a |
| <a name="output_keyvault_id"></a> [keyvault\_id](#output\_keyvault\_id) | n/a |
| <a name="output_keyvault_name"></a> [keyvault\_name](#output\_keyvault\_name) | n/a |
| <a name="output_keyvault_uri"></a> [keyvault\_uri](#output\_keyvault\_uri) | n/a |
| <a name="output_mysql_aadadmin_identity_client_id"></a> [mysql\_aadadmin\_identity\_client\_id](#output\_mysql\_aadadmin\_identity\_client\_id) | n/a |
| <a name="output_mysql_aadadmin_identity_id"></a> [mysql\_aadadmin\_identity\_id](#output\_mysql\_aadadmin\_identity\_id) | n/a |
| <a name="output_mysql_aadadmin_identity_name"></a> [mysql\_aadadmin\_identity\_name](#output\_mysql\_aadadmin\_identity\_name) | n/a |
| <a name="output_mysql_server_fqdn"></a> [mysql\_server\_fqdn](#output\_mysql\_server\_fqdn) | n/a |
| <a name="output_mysql_server_name"></a> [mysql\_server\_name](#output\_mysql\_server\_name) | n/a |
| <a name="output_private_dns_zone_mysql_id"></a> [private\_dns\_zone\_mysql\_id](#output\_private\_dns\_zone\_mysql\_id) | n/a |
| <a name="output_private_dns_zone_postgresql_id"></a> [private\_dns\_zone\_postgresql\_id](#output\_private\_dns\_zone\_postgresql\_id) | n/a |
| <a name="output_rg_id"></a> [rg\_id](#output\_rg\_id) | n/a |
| <a name="output_rg_location"></a> [rg\_location](#output\_rg\_location) | n/a |
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
<!-- END_TF_DOCS -->
