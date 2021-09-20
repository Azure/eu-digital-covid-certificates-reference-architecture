# Create a UAMI for CSI Secrets-Store and Key Vault
resource "azurerm_user_assigned_identity" "dgc_gateway_identity" {
  location            = var.location
  resource_group_name = module.base_infra.rg_name

  name = "dgc-gateway"
}

# UAMI Role Assignments
resource "azurerm_role_assignment" "dgc_gateway_identity_kv_role_assignment" {
  # List of Roles & Scopes to grant access to.
  for_each = {
    read-metadata = {
      scope                = "${module.base_infra.keyvault_id}"
      role_definition_name = "Key Vault Reader" # Allows metadata read, NOT secret material read.
    }
    trustanchor_certificate = {
      scope                = "${module.base_infra.keyvault_id}/certificates/${azurerm_key_vault_certificate.trustanchor_certificate.name}"
      role_definition_name = "Key Vault Certificates Officer"
    }
    trustanchor_certificate_secret = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_certificate.trustanchor_certificate.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    trustanchor_certificate_key = {
      scope                = "${module.base_infra.keyvault_id}/keys/${azurerm_key_vault_certificate.trustanchor_certificate.name}"
      role_definition_name = "Key Vault Crypto User"
    }
    trustanchor_alias = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.trustanchor_alias.name}"
      role_definition_name = "Key Vault Secrets User"
    }
  }

  principal_id         = azurerm_user_assigned_identity.dgc_gateway_identity.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
}

# Database
resource "azurerm_mysql_database" "mysql_db" {
  name                = "dgc"
  resource_group_name = module.base_infra.rg_name
  server_name         = module.base_infra.mysql_server_name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Namespace
resource "kubernetes_namespace" "dgc_gateway" {
  metadata {
    name = "dgc-gateway"
  }

  depends_on = [
    module.base_infra,
  ]
}

# Deploy DGC Gateway
resource "helm_release" "dgc_gateway" {
  name              = "dgc-gateway"
  chart             = "../charts/dgc-gateway"
  namespace         = kubernetes_namespace.dgc_gateway.metadata.0.name
  dependency_update = true

  wait          = true
  wait_for_jobs = true
  timeout       = 300

  values = [
    jsonencode({
      "ingress" = {
        "enabled" = "true"

        "annotations" = {
          "kubernetes.io/ingress.class"                  = "haproxy"
          "cert-manager.io/cluster-issuer"               = "letsencrypt"
          "ingress.kubernetes.io/auth-tls-secret"        = "dgc-gateway/dgc-gateway"
          "ingress.kubernetes.io/auth-tls-verify-client" = "optional_no_ca"
          "ingress.kubernetes.io/config-backend"         = <<-EOT
            http-request set-header X-SSL-Client-SHA256 %[ssl_c_der,sha2(256),hex]
            http-request set-header X-SSL-Client-DN C=%%{+Q}[ssl_c_s_dn(c)]
          EOT
        }

        "hosts" = [{
          "host" = "dgc-gateway.${module.base_infra.dns_zone_name}"
          "paths" = [{
            "path"     = "/"
            "pathType" = "Prefix"
          }]
        }]

        "tls" = [{
          "secretName" = "dgc-gateway-tls"
          "hosts" = [
            "dgc-gateway.${module.base_infra.dns_zone_name}"
          ]
        }]
      }

      "image" = {
        "repository" = "${module.base_infra.acr_login_server}/eu-digital-green-certificates/dgc-gateway"
        "tag"        = var.gateway_version
      }

      "utility" = {
        "image" = {
          "repository" = "${module.base_infra.acr_login_server}/utility"
          "tag"        = var.utility_image_tag
        }
      }

      "spring" = {
        "datasource" = {
          "url"      = "jdbc:mysql://${module.base_infra.mysql_server_fqdn}:3306/${azurerm_mysql_database.mysql_db.name}?useSSL=true&requireSSL=true"
          "username" = "${azurerm_user_assigned_identity.dgc_gateway_identity.name}@${module.base_infra.mysql_server_name}"
        }
      }

      "azure" = {
        "keyvault" = {
          "enabled" = true
          "uri"     = module.base_infra.keyvault_uri
        }
      }

      "database" = {
        "host" = module.base_infra.mysql_server_fqdn
        "name" = azurerm_mysql_database.mysql_db.name
      }

      "trustedParties" = jsondecode(file("${path.module}/../certs/trusted-parties.json"))

      "aadPodIdentity" = {
        "enabled"    = true
        "resourceID" = azurerm_user_assigned_identity.dgc_gateway_identity.id
        "clientID"   = azurerm_user_assigned_identity.dgc_gateway_identity.client_id
      }

      "secretProviderClass" = {
        "tenantId"                      = var.tenant_id
        "keyvaultName"                  = module.base_infra.keyvault_name
        "trustanchorCertificateName"    = azurerm_key_vault_certificate.trustanchor_certificate.name
        "trustanchorCertificateVersion" = azurerm_key_vault_certificate.trustanchor_certificate.version
      }
    }),

    // MySQL AAD Setup Subchart Values
    jsonencode({
      "mysql-aad-setup" = {
        "image" = {
          "repository" = "${module.base_infra.acr_login_server}/utility"
          "tag"        = var.utility_image_tag
        }

        "database" = {
          "host"      = module.base_infra.mysql_server_fqdn
          "name"      = azurerm_mysql_database.mysql_db.name
          "adminUser" = "${module.base_infra.mysql_aadadmin_identity_name}@${module.base_infra.mysql_server_name}"
          "user"      = azurerm_user_assigned_identity.dgc_gateway_identity.name
          "clientID"  = azurerm_user_assigned_identity.dgc_gateway_identity.client_id
        }

        "aadPodIdentity" = {
          "enabled"    = true
          "resourceID" = module.base_infra.mysql_aadadmin_identity_id
          "clientID"   = module.base_infra.mysql_aadadmin_identity_client_id
        }
      }
    }),
  ]

  set_sensitive {
    # As "ca.crt" is public info, no need to store in KV.
    name  = "dgc.trustanchor_cert_content"
    value = filebase64("${path.module}/../certs/cert_ta.pem")
  }

  depends_on = [
    module.base_infra,
    azurerm_mysql_database.mysql_db,
    kubernetes_namespace.dgc_gateway,
    azurerm_role_assignment.dgc_gateway_identity_kv_role_assignment,
  ]
}
