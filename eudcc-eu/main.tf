# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Load the Dev Env Remote State
data "terraform_remote_state" "dev" {
  # backend   = "azurerm"
  # workspace = terraform.workspace
  # config = {
  #   storage_account_name = "eudgctfstate"
  #   container_name       = "eudgc-dev"
  #   key                  = "terraform.tfstate"

  #   use_azuread_auth = true
  #   subscription_id  = var.subscription_id
  #   tenant_id        = var.tenant_id
  # }
  backend = "local"

  config = {
    path = "../eudcc-dev/terraform.tfstate"
  }
}

locals {
  name = "eudcc-eu"
}

# Deploy the Base Infrastructure
module "base_infra" {
  source = "../terraform-modules/base-infrastructure"

  prefix     = var.prefix
  generation = var.generation
  name       = local.name
  location   = var.location

  dev_vnet_rg_name = data.terraform_remote_state.dev.outputs.eu_rg_name
  dev_vnet_id      = data.terraform_remote_state.dev.outputs.eu_vnet_id
  dev_vnet_name    = data.terraform_remote_state.dev.outputs.eu_vnet_name

  parent_dns_zone_name    = var.parent_dns_zone_name
  parent_dns_zone_rg_name = var.parent_dns_zone_rg_name

  jump_box_identity_file = var.jump_box_identity_file
  jump_box_identity_host = var.jump_box_identity_host
  jump_box_identity_user = var.jump_box_identity_user

  administrator_group_oid = var.administrator_group_oid

  enable_log_analytics_workspace = var.enable_log_analytics_workspace
  log_analytics_cluster_id       = var.log_analytics_cluster_id

  acr_imports = {
    dgc-gateway = {
      source      = "ghcr.io/azure/eu-digital-covid-certificates-reference-architecture/dgc-gateway:${var.gateway_version}"
      destination = "eu-digital-covid-certificates/dgc-gateway:${var.gateway_version}"
      username    = var.ghcr_username
      password    = var.ghcr_password
    }
    utility = {
      source      = "ghcr.io/azure/eu-digital-covid-certificates-reference-architecture/utility:${var.utility_image_tag}"
      destination = "eu-digital-covid-certificates/utility:${var.utility_image_tag}"
      username    = var.ghcr_username
      password    = var.ghcr_password
    }
  }

  aad_pod_identity_immutable_uamis = [
    azurerm_user_assigned_identity.dgc_gateway_identity.client_id,
  ]

  providers = {
    azurerm = azurerm
  }
}
