# Network & Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}${var.name}-vnet"
  address_space       = ["192.168.4.0/22"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}${var.name}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["192.168.4.0/23"]

  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.ContainerRegistry" # TODO: Validate if this is needed now that ACR Private Link is enabled
  ]
}

# NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}${var.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a two way VNet Peering to the Dev network.
# TODO: Ideally, this wouldn't be hardcoded/required..
resource "azurerm_virtual_network_peering" "to-dev" {
  name                      = "${var.prefix}${var.name}-to-dev"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.dev_vnet_id
}

resource "azurerm_virtual_network_peering" "from-dev" {
  name                      = "${var.prefix}${var.name}-from-dev"
  resource_group_name       = var.dev_vnet_rg_name
  virtual_network_name      = var.dev_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}
