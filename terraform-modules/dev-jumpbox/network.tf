# Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}${var.name}-vnet"
  address_space       = ["192.168.0.0/22"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                                           = "${var.prefix}${var.name}-subnet"
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  resource_group_name                            = azurerm_resource_group.rg.name
  address_prefixes                               = ["192.168.0.0/23"]
  enforce_private_link_endpoint_network_policies = true
}
