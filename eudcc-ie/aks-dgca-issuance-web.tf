# Create a UAMI
resource "azurerm_user_assigned_identity" "dgca_issuance_web_identity" {
  location            = module.base_infra.rg_location
  resource_group_name = module.base_infra.rg_name

  name = "dgca-issuance-web"
}

# UAMI Role Assignments
resource "azurerm_user_assigned_identity" "msal_authentication" {
  location            = module.base_infra.rg_location
  resource_group_name = module.base_infra.rg_name

  name = "dgca-issuance-web-msal"
}

resource "random_uuid" "web_auth_oauth2_scope" {}

data "azuread_client_config" "current" {}
# Namespace
resource "kubernetes_namespace" "dgca_issuance_web" {
  metadata {
    name = "dgca-issuance-web"
  }

  depends_on = [
    module.base_infra,
  ]
}

locals {
  hostname = "dgca-issuance-web.${module.base_infra.dns_zone_name}"
}

resource "azuread_application" "msal_authentication" {
  display_name     = local.hostname
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"
  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access ${local.hostname} on behalf of the signed-in user."
      admin_consent_display_name = "Access ${local.hostname}"
      user_consent_description   = "Allow the application to access ${local.hostname} on behalf of the signed-in user."
      user_consent_display_name  = "Access ${local.hostname}"
      id                         = random_uuid.web_auth_oauth2_scope.result
      value                      = "user_impersonation"
    }

  }
  web {
    homepage_url  = "https://${local.hostname}"
    redirect_uris = ["https://${local.hostname}/msal/signin-oidc"]
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }
}

resource "azuread_service_principal" "msal_authentication" {
  application_id = azuread_application.msal_authentication.application_id
  tags = [
    "AppServiceIntegratedApp",
    "WindowsAzureActiveDirectoryIntegratedApp",
  ]
}

resource "azuread_application_password" "msal_authentication" {
  application_object_id = azuread_application.msal_authentication.object_id
}


# Deploy DGCA Issuance Web
resource "helm_release" "dgca_issuance_web" {
  name      = "dgca-issuance-web"
  chart     = "../charts/dgca-issuance-web"
  namespace = "dgca-issuance-web"

  values = [
    jsonencode({
      "ingress" = {
        "enabled" = "true"

        "annotations" = {
          "kubernetes.io/ingress.class"       = "haproxy"
          "cert-manager.io/cluster-issuer"    = "letsencrypt"
          "ingress.kubernetes.io/auth-url"    = "https://${local.hostname}/msal/auth"
          "ingress.kubernetes.io/auth-signin" = "https://${local.hostname}/msal/index"
        }

        "hosts" = [{
          "host" = local.hostname
          "paths" = [{
            "path"     = "/"
            "pathType" = "Prefix"
          }]
        }]

        "tls" = [{
          "secretName" = "dgca-issuance-web-tls"
          "hosts" = [
            local.hostname
          ]
        }]
      }

      "image" = {
        "repository" = "${module.base_infra.acr_login_server}/eu-digital-covid-certificates/dgca-issuance-web"
        "tag"        = var.issuance_web_version
      }

      "dgc" = {
        "issuance_service_url" : "http://dgca-issuance-service.dgca-issuance-service.svc.cluster.local/"
        "businessrule_service_url" : "http://dgca-businessrule-service.dgca-businessrule-service.svc.cluster.local/"
      }

      "aadPodIdentity" = {
        "enabled" : true
        "resourceID" : azurerm_user_assigned_identity.dgca_issuance_web_identity.id
        "clientID" : azurerm_user_assigned_identity.dgca_issuance_web_identity.client_id
      }
    })
  ]

  depends_on = [
    module.base_infra,
    kubernetes_namespace.dgca_issuance_web,
    helm_release.dgca_issuance_service,
    helm_release.dgca_businessrule_service,
    helm_release.msal_authentication,
  ]
}

resource "azurerm_key_vault_secret" "msal_authentication_client_secret" {
  name         = "msal-authentication-client-secret"
  value        = azuread_application_password.msal_authentication.value
  key_vault_id = module.base_infra.keyvault_id

  depends_on = [
    module.base_infra,
  ]
}

resource "azurerm_role_assignment" "msal_identity_kv_role_assignment" {
  # List of Roles & Scopes to grant access to.
  for_each = {
    client-secret = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.msal_authentication_client_secret.name}"
      role_definition_name = "Key Vault Secrets User"
    }
  }

  principal_id         = azurerm_user_assigned_identity.msal_authentication.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name

}

resource "helm_release" "msal_authentication" {
  name      = "msal-authentication"
  chart     = "../charts/msal-authentication"
  namespace = "dgca-issuance-web"

  values = [
    jsonencode({
      "ingress" = {

        "enabled" = "true"

        "annotations" = {
          "kubernetes.io/ingress.class"    = "haproxy"
          "cert-manager.io/cluster-issuer" = "letsencrypt"
        }

        "hosts" = [{
          "host" = local.hostname
          "paths" = [{
            "path"     = "/msal"
            "pathType" = "Prefix"
          }]
        }]

        "tls" = [{
          "secretName" = "dgca-issuance-web-tls"
          "hosts" = [
            local.hostname
          ]
        }]
      }

      "image" = {
        "repository" = "${module.base_infra.acr_login_server}/eu-digital-covid-certificates/msal-net-proxy"
        "tag"        = var.msal_proxy_version
      }

      "client_id" = azuread_application.msal_authentication.application_id
      "tenant_id" = var.tenant_id

      "aadPodIdentity" = {
        "enabled" : true
        "resourceID" : azurerm_user_assigned_identity.msal_authentication.id
        "clientID" : azurerm_user_assigned_identity.msal_authentication.client_id
      }

      "secretProviderClass" = {
        "tenantId" : var.tenant_id
        "keyvaultName" : module.base_infra.keyvault_name
        "ClientSecret" : azurerm_key_vault_secret.msal_authentication_client_secret.name
      }
    })
  ]

  depends_on = [
    module.base_infra,
    azurerm_role_assignment.msal_identity_kv_role_assignment
  ]
}
