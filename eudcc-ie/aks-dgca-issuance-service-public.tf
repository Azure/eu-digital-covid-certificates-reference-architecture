# Create a UAMI
resource "azurerm_user_assigned_identity" "dgca_issuance_service_public_identity" {
  location            = module.base_infra.rg_location
  resource_group_name = module.base_infra.rg_name

  name = "dgca-issuance-service-public"
}

# UAMI Role Assignments
resource "azurerm_role_assignment" "dgca_issuance_service_public_kv_role_assignment" {
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
    # TODO: This service shouldn't need the TLS Key Store?
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
    # TODO: This service shouldn't need the Upload Key Store?
    upload_key_store_certificate = {
      scope                = "${module.base_infra.keyvault_id}/certificates/${azurerm_key_vault_certificate.upload_key_store_certificate.name}"
      role_definition_name = "Key Vault Certificates Officer"
    }
    upload_key_store_certificate_secret = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_certificate.upload_key_store_certificate.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    upload_key_store_certificate_key = {
      scope                = "${module.base_infra.keyvault_id}/keys/${azurerm_key_vault_certificate.upload_key_store_certificate.name}"
      role_definition_name = "Key Vault Crypto User"
    }
    upload_key_store_alias = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.upload_key_store_alias.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    # TODO: This service shouldn't need the DSC Key Store?
    dsc_key_store_certificate = {
      scope                = "${module.base_infra.keyvault_id}/certificates/${azurerm_key_vault_certificate.dsc_key_store_certificate.name}"
      role_definition_name = "Key Vault Certificates Officer"
    }
    dsc_key_store_certificate_secret = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_certificate.dsc_key_store_certificate.name}"
      role_definition_name = "Key Vault Secrets User"
    }
    dsc_key_store_certificate_key = {
      scope                = "${module.base_infra.keyvault_id}/keys/${azurerm_key_vault_certificate.dsc_key_store_certificate.name}"
      role_definition_name = "Key Vault Crypto User"
    }
    dsc_key_store_alias = {
      scope                = "${module.base_infra.keyvault_id}/secrets/${azurerm_key_vault_secret.dsc_key_store_alias.name}"
      role_definition_name = "Key Vault Secrets User"
    }
  }

  principal_id         = azurerm_user_assigned_identity.dgca_issuance_service_public_identity.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
}

# Namespace
resource "kubernetes_namespace" "dgca_issuance_service_public" {
  metadata {
    name = "dgca-issuance-service-public"
  }

  depends_on = [
    module.base_infra,
  ]
}

# Deploy DGCA Issuance Service
resource "helm_release" "dgca_issuance_service_public" {
  name              = "dgca-issuance-service-public"
  chart             = "../charts/dgca-issuance-service"
  namespace         = "dgca-issuance-service-public"
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
          "host" = "dgca-issuance-service.${module.base_infra.dns_zone_name}"
          "paths" = [{
            "path"     = "/"
            "pathType" = "Prefix"
          }]
        }]

        "tls" = [{
          "secretName" = "dgca-issuance-service-public-tls"
          "hosts" = [
            "dgca-issuance-service.${module.base_infra.dns_zone_name}"
          ]
        }]
      }

      "image" = {
        "repository" = "${module.base_infra.acr_login_server}/eu-digital-green-certificates/dgca-issuance-service"
        "tag"        = var.issuance_service_version
      }

      "utility" = {
        "image" = {
          "repository" = "${module.base_infra.acr_login_server}/utility"
          "tag"        = var.utility_image_tag
        }
      }

      "spring" = {
        "datasource" = {
          "url" : "jdbc:mysql://${module.base_infra.mysql_server_fqdn}:3306/${azurerm_mysql_database.issuance_service_db.name}?useSSL=true&requireSSL=true"
          "username" : "${azurerm_user_assigned_identity.dgca_issuance_service_public_identity.name}@${module.base_infra.mysql_server_name}"
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
            "enabled" : false
            "endpoint" : "https://${local.dgc_gateway_fqdn}/"
          }
        }
      }

      "issuance" = {
        "countryCode" : "IE"
        "dgciPrefix" : "URN:UVCI:V1:IE"
        "endpoints" = {
          "frontendIssuing" : false
          "backendIssuing" : false
          "testTools" : false
          "wallet" : true
          "publishCert" : false
          "did" : true
        }
      }

      "context" = {
        "issuance_service_url"     = "https://dgca-issuance-service.${module.base_infra.dns_zone_name}"
        "businessrule_service_url" = "https://dgca-businessrule-service.${module.base_infra.dns_zone_name}"
        "public_key_pin"           = "C5+lpZ7tcVwmwQIMcRtPbsQtWLABXhQzejna0wHFr8M=" # LetsEncrypt X1 CA
      }

      "aadPodIdentity" = {
        "enabled" : true
        "resourceID" : azurerm_user_assigned_identity.dgca_issuance_service_public_identity.id
        "clientID" : azurerm_user_assigned_identity.dgca_issuance_service_public_identity.client_id
      }

      "secretProviderClass" = {
        "tenantId"                   = var.tenant_id
        "keyvaultName"               = module.base_infra.keyvault_name
        "trustanchorSecretName"      = azurerm_key_vault_secret.trustanchor_content.name
        "trustanchorSecretVersion"   = azurerm_key_vault_secret.trustanchor_content.version
        "tlsTrustStoreSecretName"    = azurerm_key_vault_secret.tls_trust_store_content.name
        "tlsTrustStoreSecretVersion" = azurerm_key_vault_secret.tls_trust_store_content.version
        # TODO: This service shouldn't need the TLS/Upload/DSC Key Stores?
        "tlsKeyStoreCertificateName"       = azurerm_key_vault_certificate.tls_key_store_certificate.name
        "tlsKeyStoreCertificateVersion"    = azurerm_key_vault_certificate.tls_key_store_certificate.version
        "uploadKeyStoreCertificateName"    = azurerm_key_vault_certificate.upload_key_store_certificate.name
        "uploadKeyStoreCertificateVersion" = azurerm_key_vault_certificate.upload_key_store_certificate.version
        "dscKeyStoreCertificateName"       = azurerm_key_vault_certificate.dsc_key_store_certificate.name
        "dscKeyStoreCertificateVersion"    = azurerm_key_vault_certificate.dsc_key_store_certificate.version
      }
    }),

    // Mysql AAD Setup Subchart Values
    jsonencode({
      "mysql-aad-setup" = {
        "image" = {
          "repository" = "${module.base_infra.acr_login_server}/utility"
          "tag"        = var.utility_image_tag
        }

        "database" = {
          "host"      = module.base_infra.mysql_server_fqdn
          "name"      = azurerm_mysql_database.issuance_service_db.name
          "adminUser" = "${module.base_infra.mysql_aadadmin_identity_name}@${module.base_infra.mysql_server_name}"
          "user"      = azurerm_user_assigned_identity.dgca_issuance_service_public_identity.name
          "clientID"  = azurerm_user_assigned_identity.dgca_issuance_service_public_identity.client_id
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
    azurerm_mysql_database.businessrule_service_db,
    kubernetes_namespace.dgca_issuance_service_public,
    azurerm_role_assignment.dgca_issuance_service_public_kv_role_assignment,
  ]
}
