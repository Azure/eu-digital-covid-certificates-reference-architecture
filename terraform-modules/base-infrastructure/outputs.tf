output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "rg_id" {
  value = azurerm_resource_group.rg.id
}

output "rg_location" {
  value = azurerm_resource_group.rg.location
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "keyvault_id" {
  value = azurerm_key_vault.keyvault.id
}

output "keyvault_name" {
  value = azurerm_key_vault.keyvault.name
}

output "keyvault_uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}

output "dns_zone_name" {
  value = azurerm_dns_zone.dns.name
}

output "private_dns_zone_mysql_id" {
  value = azurerm_private_dns_zone.private_dns_zone_mysql.id
}

output "aks_private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "aks_username" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config.0.username
}

output "aks_password" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config.0.password
  sensitive = true
}

output "aks_client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate
}

output "aks_client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key
  sensitive = true
}

output "aks_cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "mysql_server_name" {
  value = azurerm_mysql_server.mysql.name
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_server.mysql.fqdn
}

output "mysql_aadadmin_identity_id" {
  value = azurerm_user_assigned_identity.mysql_aadadmin_identity.id
}

output "mysql_aadadmin_identity_client_id" {
  value = azurerm_user_assigned_identity.mysql_aadadmin_identity.client_id
}

output "mysql_aadadmin_identity_name" {
  value = azurerm_user_assigned_identity.mysql_aadadmin_identity.name
}
