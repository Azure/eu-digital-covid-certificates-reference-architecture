# When adding/removing values, you MUST update azure.keyvault.secret-keys
#
# Docs: https://github.com/Azure/azure-sdk-for-java/tree/3f31d68eed6fbe11516ca3afe3955c8840a6e974/sdk/spring/azure-spring-boot-starter-keyvault-secrets
# Naming Algo: https://github.com/Azure/azure-sdk-for-java/blob/3f31d68eed6fbe11516ca3afe3955c8840a6e974/sdk/spring/azure-spring-boot/src/main/java/com/azure/spring/keyvault/KeyVaultOperation.java#L165-L177

# TrustAnchor
resource "azurerm_key_vault_certificate" "trustanchor_certificate" {
  name         = "trustanchor"
  key_vault_id = module.base_infra.keyvault_id

  certificate {
    contents = filebase64("${path.module}/../certs/ta.p12")
    password = "dgcg-p4ssw0rd" # FIXME
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 4096
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

resource "azurerm_key_vault_secret" "trustanchor_alias" {
  name         = "dgc-trustanchor-certificatealias"
  value        = "dgcg_trust_anchor" # FIXME
  key_vault_id = module.base_infra.keyvault_id
  depends_on = [
    module.base_infra,
  ]
}
