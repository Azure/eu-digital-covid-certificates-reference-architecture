---
title: "Jumpbox Terraform Module"
linkTitle: "Jumpbox Module"
weight: 20
---

{{< tf-generated-warning >}}

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =2.71.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | =3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =2.71.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | =3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.jumpbox_vm](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.jumpbox_vm_nic](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.jumpbox_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.jumpbox_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.jumpbox_vm_pip](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.jumpbox_vm_aad_admins](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.jumpbox_vm_aad_users](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/role_assignment) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/subnet) | resource |
| [azurerm_virtual_machine_extension.jumpbox_vm_aad](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/resources/virtual_network) | resource |
| [tls_private_key.jumpbox_vm_ssh](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.71.0/docs/data-sources/client_config) | data source |
| [http_http.local_external_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_group_oid"></a> [administrator\_group\_oid](#input\_administrator\_group\_oid) | OID of the Group to grant Administrator permissions | `string` | n/a | yes |
| <a name="input_jumpbox_ssh_source_address_prefixes"></a> [jumpbox\_ssh\_source\_address\_prefixes](#input\_jumpbox\_ssh\_source\_address\_prefixes) | List of prefixes allowed to SSH to Jumpbox VM | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location Name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Environment Name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rg_id"></a> [rg\_id](#output\_rg\_id) | n/a |
| <a name="output_rg_location"></a> [rg\_location](#output\_rg\_location) | n/a |
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
<!-- END_TF_DOCS -->
