# Create a UAMI
resource "azurerm_user_assigned_identity" "dgca_verifier_service_identity" {
  location            = module.base_infra.rg_location
  resource_group_name = module.base_infra.rg_name

  name = "dgca-verifier-service"
}

# UAMI Role Assignments
resource "azurerm_role_assignment" "dgca_verifier_service_kv_role_assignment" {
  # List of Roles & Scopes to grant access to.
  for_each = {
    read-metadata = {
      scope                = "${module.base_infra.keyvault_id}"
      role_definition_name = "Key Vault Reader" # Allows metadata read, NOT secret material read.
    }
    trustanchor_content = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.trustanchor_content.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    trustanchor_password = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.trustanchor_password.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    trustanchor_alias = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.trustanchor_alias.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    tls_trust_store_content = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.tls_trust_store_content.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    tls_trust_store_password = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.tls_trust_store_password.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    tls_key_store_certificate = {
      scope                = "${module.base_infra.keyvault_id}/certificates/${azurerm_key_vault_certificate.tls_key_store_certificate.name}"
      role_definition_name = "Key Vault Certificates Officer"
    }
    tls_key_store_certificate_secret = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_certificate.tls_key_store_certificate.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    tls_key_store_certificate_key = {
      scope                = "${module.base_infra.keyvault_id}/keys/${azurerm_key_vault_certificate.tls_key_store_certificate.name}"
      role_definition_name = "Key Vault Crypto User"
    }
    tls_key_store_alias = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.tls_key_store_alias.name}"
      role_definition_name = "Key Vault Secrets User"
    }
  }
  principal_id         = azurerm_user_assigned_identity.dgca_verifier_service_identity.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
}


# Database
resource "azurerm_mysql_database" "verifier_service_db" {
  name                = "verifier-service"
  resource_group_name = module.base_infra.rg_name
  server_name         = module.base_infra.mysql_server_name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Namespace
resource "kubernetes_namespace" "dgca_verifier_service" {
  metadata {
    name = "dgca-verifier-service"
  }

  depends_on = [
    module.base_infra,
  ]
}


# Deploy DGCA Verifier Service
resource "helm_release" "dgca_verifier_service" {
  name              = "dgca-verifier-service"
  chart             = "../charts/dgca-verifier-service"
  namespace         = "dgca-verifier-service"
  dependency_update = true

  wait          = true
  wait_for_jobs = true
  timeout       = 300

  values = [
    jsonencode({
      "ingress" = {
        "enabled" = "true"

        "annotations" = {
          "kubernetes.io/ingress.class"    = "haproxy"
          "cert-manager.io/cluster-issuer" = "letsencrypt"
        }

        "hosts" = [{
          "host" = "dgca-verifier-service.${module.base_infra.dns_zone_name}"
          "paths" = [{
            "path"     = "/"
            "pathType" = "Prefix"
          }]
        }]

        "tls" = [{
          "secretName" = "dgca-verifier-service-public-tls"
          "hosts" = [
            "dgca-verifier-service.${module.base_infra.dns_zone_name}"
          ]
        }]
      }

      "image" = {
        "repository" = "${module.base_infra.acr_login_server}/eu-digital-covid-certificates/dgca-verifier-service"
        "tag"        = var.verifier_service_version
      }

      "utility" = {
        "image" = {
          "repository" = "${module.base_infra.acr_login_server}/eu-digital-covid-certificates/utility"
          "tag"        = var.utility_image_tag
        }
      }

      "nginx" = {
        "image" = {
          "repository" : "${module.base_infra.acr_login_server}/eu-digital-covid-certificates/nginx"
          "tag" : var.nginx_image_tag
        }
      }

      "spring" = {
        "datasource" = {
          "url" : "jdbc:mysql://${module.base_infra.mysql_server_fqdn}:3306/${azurerm_mysql_database.verifier_service_db.name}?useSSL=true&requireSSL=true"
          "username" : "${azurerm_user_assigned_identity.dgca_verifier_service_identity.name}@${module.base_infra.mysql_server_name}"
        }
      }

      "azure" = {
        "keyvault" = {
          "enabled" = true
          "uri"     = module.base_infra.keyvault_uri
        }
      }

      "dgc" = {
        "gateway" = {
          "connector" = {
            "endpoint" : "https://${local.dgc_gateway_fqdn}/"
          }
        }
      }

      "context" = {
        "verifier_service_url" : "https://dgca-verifier-service.${module.base_infra.dns_zone_name}"
        "businessrule_service_url" : "https://dgca-businessrule-service.${module.base_infra.dns_zone_name}"
        "issuance_service_url" : "C5+lpZ7tcVwmwQIMcRtPbsQtWLABXhQzejna0wHFr8M=" # LetsEncrypt X1 CA
      }

      "aadPodIdentity" = {
        "enabled" : true
        "resourceID" : azurerm_user_assigned_identity.dgca_verifier_service_identity.id
        "clientID" : azurerm_user_assigned_identity.dgca_verifier_service_identity.client_id
      }

      "secretProviderClass" = {
        "tenantId"                      = var.tenant_id
        "keyvaultName"                  = module.base_infra.keyvault_name
        "trustanchorSecretName"         = azurerm_key_vault_secret.trustanchor_content.name
        "trustanchorSecretVersion"      = azurerm_key_vault_secret.trustanchor_content.version
        "tlsTrustStoreSecretName"       = azurerm_key_vault_secret.tls_trust_store_content.name
        "tlsTrustStoreSecretVersion"    = azurerm_key_vault_secret.tls_trust_store_content.version
        "tlsKeyStoreCertificateName"    = azurerm_key_vault_certificate.tls_key_store_certificate.name
        "tlsKeyStoreCertificateVersion" = azurerm_key_vault_certificate.tls_key_store_certificate.version
      }
    }),

    // Mysql AAD Setup Subchart Values
    jsonencode({
      "mysql-aad-setup" = {
        "image" = {
          "repository" = "${module.base_infra.acr_login_server}/eu-digital-covid-certificates/utility"
          "tag"        = var.utility_image_tag
        }

        "database" = {
          "host"      = module.base_infra.mysql_server_fqdn
          "name"      = azurerm_mysql_database.verifier_service_db.name
          "adminUser" = "${module.base_infra.mysql_aadadmin_identity_name}@${module.base_infra.mysql_server_name}"
          "user"      = azurerm_user_assigned_identity.dgca_verifier_service_identity.name
          "clientID"  = azurerm_user_assigned_identity.dgca_verifier_service_identity.client_id
        }

        "aadPodIdentity" = {
          "enabled"    = true
          "resourceID" = module.base_infra.mysql_aadadmin_identity_id
          "clientID"   = module.base_infra.mysql_aadadmin_identity_client_id
        }
      }
    }),
  ]


  depends_on = [
    module.base_infra,
    azurerm_mysql_database.verifier_service_db,
    kubernetes_namespace.dgca_verifier_service,
    azurerm_role_assignment.dgca_verifier_service_kv_role_assignment,
  ]
}
