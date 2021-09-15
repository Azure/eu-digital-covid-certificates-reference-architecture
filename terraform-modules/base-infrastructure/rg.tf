# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}${var.name}"
  location = var.location
}
