# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
provider "azuread" {
  tenant_id = var.tenant_id
}


# Load the Dev Env Remote State
data "terraform_remote_state" "dev" {
  backend   = "azurerm"
  workspace = terraform.workspace

  config = {
    storage_account_name = "eudgctfstate"
    container_name       = "eudgc-dev"
    key                  = "terraform.tfstate"

    use_azuread_auth = true
    subscription_id  = var.subscription_id
    tenant_id        = var.tenant_id
  }
}

# Load the EU Env Remote State
data "terraform_remote_state" "eu" {
  backend   = "azurerm"
  workspace = terraform.workspace

  config = {
    storage_account_name = "eudgctfstate"
    container_name       = "eudgc-eu"
    key                  = "terraform.tfstate"

    use_azuread_auth = true
    subscription_id  = var.subscription_id
    tenant_id        = var.tenant_id
  }
}


locals {
  name             = "eudcc-ie"
  dns_zone_name    = var.prefix == "" ? local.name : "${local.name}.${var.prefix}"
  dgc_gateway_fqdn = data.terraform_remote_state.eu.outputs.dgc_gateway_fqdn
}

# Deploy the Base Infrastructure
module "base_infra" {
  source = "../terraform-modules/base-infrastructure"

  prefix   = var.prefix
  name     = local.name
  location = var.location

  dev_vnet_rg_name = data.terraform_remote_state.dev.outputs.ie_rg_name
  dev_vnet_id      = data.terraform_remote_state.dev.outputs.ie_vnet_id
  dev_vnet_name    = data.terraform_remote_state.dev.outputs.ie_vnet_name

  parent_dns_zone_name    = var.parent_dns_zone_name
  parent_dns_zone_rg_name = var.parent_dns_zone_rg_name

  administrator_group_oid = var.administrator_group_oid

  enable_log_analytics_workspace = var.enable_log_analytics_workspace
  log_analytics_cluster_id       = var.log_analytics_cluster_id
  acr_imports = {
    dgca-issuance-service = {
      source      = "ghcr.io/azure/eu-digital-covid-certificates-reference-architecture/dgca-issuance-service:${var.issuance_service_version}"
      destination = "eu-digital-covid-certificates/dgca-issuance-service:${var.issuance_service_version}"
      username    = var.ghcr_username
      password    = var.ghcr_password
    }
    dgca-issuance-web = {
      source      = "ghcr.io/azure/eu-digital-covid-certificates-reference-architecture/dgca-issuance-web:${var.issuance_web_version}"
      destination = "eu-digital-covid-certificates/dgca-issuance-web:${var.issuance_web_version}"
      username    = var.ghcr_username
      password    = var.ghcr_password
    }
    dgca-businessrule-service = {
      source      = "ghcr.io/azure/eu-digital-covid-certificates-reference-architecture/dgca-businessrule-service:${var.businessrule_service_version}"
      destination = "eu-digital-covid-certificates/dgca-businessrule-service:${var.businessrule_service_version}"
      username    = var.ghcr_username
      password    = var.ghcr_password
    }
    dgca-verifier-service = {
      source      = "ghcr.io/azure/eu-digital-covid-certificates-reference-architecture/dgca-verifier-service:${var.verifier_service_version}"
      destination = "eu-digital-covid-certificates/dgca-verifier-service:${var.verifier_service_version}"
      username    = var.ghcr_username
      password    = var.ghcr_password
    }
    utility = {
      source      = "ghcr.io/azure/eu-digital-covid-certificates-reference-architecture/utility:${var.utility_image_tag}"
      destination = "eu-digital-covid-certificates/utility:${var.utility_image_tag}"
      username    = var.ghcr_username
      password    = var.ghcr_password
    }
    nginx = {
      # Used by DGCA Verifier Service Context Sidecar
      source      = "docker.io/library/nginx:${var.nginx_image_tag}"
      destination = "eu-digital-covid-certificates/nginx:${var.nginx_image_tag}"
    }
    # TODO: Using the `latest` tag is bad practice, we'll work with the upstream team to
    #       get some better tags applied to the image.
    msal-net-proxy = {
      source      = "docker.io/easyauthfork8s/msal-net-proxy-opt:${var.msal_proxy_version}"
      destination = "eu-digital-covid-certificates/msal-net-proxy-opt:${var.msal_proxy_version}"
    }
  }

  aad_pod_identity_immutable_uamis = [
    azurerm_user_assigned_identity.dgca_businessrule_service_identity.client_id,
    azurerm_user_assigned_identity.dgca_issuance_service_public_identity.client_id,
    azurerm_user_assigned_identity.dgca_issuance_service_identity.client_id,
    azurerm_user_assigned_identity.dgca_issuance_web_identity.client_id,
    azurerm_user_assigned_identity.dgca_verifier_service_identity.client_id,
    azurerm_user_assigned_identity.msal_authentication.client_id
  ]

  providers = {
    azurerm = azurerm
  }
}
