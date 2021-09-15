# When adding/removing values, you MUST update azure.keyvault.secret-keys Helm value
#
# Docs: https://github.com/Azure/azure-sdk-for-java/tree/3f31d68eed6fbe11516ca3afe3955c8840a6e974/sdk/spring/azure-spring-boot-starter-keyvault-secrets
# Naming Algo: https://github.com/Azure/azure-sdk-for-java/blob/3f31d68eed6fbe11516ca3afe3955c8840a6e974/sdk/spring/azure-spring-boot/src/main/java/com/azure/spring/keyvault/KeyVaultOperation.java#L165-L177

# Set TrustAnchor Sercet to Key Vault.
resource "azurerm_key_vault_secret" "trustanchor_content" {
  name         = "trustanchor-content"
  value        = filebase64("${path.module}/../certs/ta.p12")
  key_vault_id = module.base_infra.keyvault_id
  content_type = "application/x-pkcs12"

  depends_on = [
    module.base_infra,
  ]
}

resource "azurerm_key_vault_secret" "trustanchor_password" {
  name         = "dgc-gateway-connector-trustanchor-password"
  value        = "dgcg-p4ssw0rd" # FIXME
  key_vault_id = module.base_infra.keyvault_id

  depends_on = [
    module.base_infra,
  ]
}

resource "azurerm_key_vault_secret" "trustanchor_alias" {
  name         = "dgc-gateway-connector-trustanchor-alias"
  value        = "dgcg_trust_anchor"
  key_vault_id = module.base_infra.keyvault_id

  depends_on = [
    module.base_infra,
  ]
}

# Set tls_trust_store.jks Sercet to Key Vault.
resource "azurerm_key_vault_secret" "tls_trust_store_content" {
  name         = "tls-trust-store-content"
  value        = filebase64("${path.module}/../certs/tls_trust_store.p12")
  key_vault_id = module.base_infra.keyvault_id
  content_type = "application/x-pkcs12"

  depends_on = [
    module.base_infra,
  ]
}

resource "azurerm_key_vault_secret" "tls_trust_store_password" {
  name         = "dgc-gateway-connector-tlstruststore-password"
  value        = "dgcg-p4ssw0rd" # FIXME
  key_vault_id = module.base_infra.keyvault_id

  depends_on = [
    module.base_infra,
  ]
}

# Set TLS Key Store / auth.p12 Sercet to Key Vault.
resource "azurerm_key_vault_certificate" "tls_key_store_certificate" {
  name         = "tls-key-store"
  key_vault_id = module.base_infra.keyvault_id

  certificate {
    contents = filebase64("${path.module}/../certs/IE_auth.p12")
    password = "dgcg-p4ssw0rd" # FIXME
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true # Reuse Key on Cert Renewal
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }

  depends_on = [
    module.base_infra,
  ]
}

resource "azurerm_key_vault_secret" "tls_key_store_alias" {
  name         = "dgc-gateway-connector-tlskeystore-alias"
  value        = "auth"
  key_vault_id = module.base_infra.keyvault_id

  depends_on = [
    module.base_infra,
  ]
}

# Set IE_upload.p12 Sercet to Key Vault.
resource "azurerm_key_vault_certificate" "upload_key_store_certificate" {
  name         = "upload-key-store"
  key_vault_id = module.base_infra.keyvault_id

  certificate {
    contents = filebase64("${path.module}/../certs/IE_upload.p12")
    password = "dgcg-p4ssw0rd" # FIXME
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true # Reuse Key on Cert Renewal
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }

  depends_on = [
    module.base_infra,
  ]
}

resource "azurerm_key_vault_secret" "upload_key_store_alias" {
  name         = "dgc-gateway-connector-uploadkeystore-alias"
  value        = "upload"
  key_vault_id = module.base_infra.keyvault_id

  depends_on = [
    module.base_infra,
  ]
}

# Set IE_dsc.p12 Sercet to Key Vault.
resource "azurerm_key_vault_certificate" "dsc_key_store_certificate" {
  name         = "dsc-key-store"
  key_vault_id = module.base_infra.keyvault_id

  certificate {
    contents = filebase64("${path.module}/../certs/IE_dsc.p12")
    password = "dgcg-p4ssw0rd" # FIXME
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true # Reuse Key on Cert Renewal
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }

  depends_on = [
    module.base_infra,
  ]
}

resource "azurerm_key_vault_secret" "dsc_key_store_alias" {
  name         = "issuance-certalias"
  value        = "dsc"
  key_vault_id = module.base_infra.keyvault_id

  depends_on = [
    module.base_infra,
  ]
}
