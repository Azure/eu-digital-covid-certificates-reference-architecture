# DNS Zone
locals {
  dns_zone_name = var.prefix == "" ? var.name : "${var.name}.${var.prefix}"
}
resource "azurerm_dns_zone" "dns" {
  name                = "${local.dns_zone_name}.${var.parent_dns_zone_name}"
  resource_group_name = azurerm_resource_group.rg.name
}

# DNS Zone delegration from Parent
resource "azurerm_dns_ns_record" "dns_delegation" {
  name                = local.dns_zone_name
  zone_name           = var.parent_dns_zone_name
  resource_group_name = var.parent_dns_zone_rg_name
  ttl                 = 300
  records             = azurerm_dns_zone.dns.name_servers
}

# ACR Private Link DNS Zone
resource "azurerm_private_dns_zone" "private_dns_zone_acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_acr_link" {
  name                  = "private-dns-zone-acr-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_acr.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_acr_link_dev" {
  name                  = "private-dns-zone-acr-link-dev"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_acr.name
  virtual_network_id    = var.dev_vnet_id
}

# AKS Private Link DNS Zone
resource "azurerm_private_dns_zone" "private_dns_zone_aks" {
  name                = "privatelink.${azurerm_resource_group.rg.location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_aks_link" {
  name                  = "private-dns-zone-aks-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_aks.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_aks_link_dev" {
  name                  = "private-dns-zone-aks-link-dev"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_aks.name
  virtual_network_id    = var.dev_vnet_id
}

# KeyVault Private Link DNS Zone
resource "azurerm_private_dns_zone" "private_dns_zone_keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_keyvault_link" {
  name                  = "private-dns-zone-keyvault-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_keyvault.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_keyvault_link_dev" {
  name                  = "private-dns-zone-keyvault-link-dev"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_keyvault.name
  virtual_network_id    = var.dev_vnet_id
}

# MySQL Private Link DNS Zone
# TODO: This should be made optional, as not all base_infra users require it.
resource "azurerm_private_dns_zone" "private_dns_zone_mysql" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_mysql_link" {
  name                  = "private-dns-zone-mysql-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_mysql.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_mysql_link_dev" {
  name                  = "private-dns-zone-mysql-link-dev"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_mysql.name
  virtual_network_id    = var.dev_vnet_id
}
