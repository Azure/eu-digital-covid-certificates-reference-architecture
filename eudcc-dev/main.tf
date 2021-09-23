# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  name = "eudcc-dev"
}

# Deploy the EU Dev Jumpbox
module "eu_dev_jumpbox" {
  source = "../terraform-modules/dev-jumpbox"

  prefix   = var.prefix
  name     = "${local.name}-eu"
  location = var.location

  administrator_group_oid = var.administrator_group_oid

  jumpbox_ssh_source_address_prefixes = var.jumpbox_ssh_source_address_prefixes

  providers = {
    azurerm = azurerm
  }
}

# Deploy the IE Dev Jumpbox
module "ie_dev_jumpbox" {
  source = "../terraform-modules/dev-jumpbox"

  prefix   = var.prefix
  name     = "${local.name}-ie"
  location = var.location

  administrator_group_oid = var.administrator_group_oid

  jumpbox_ssh_source_address_prefixes = var.jumpbox_ssh_source_address_prefixes

  providers = {
    azurerm = azurerm
  }
}
