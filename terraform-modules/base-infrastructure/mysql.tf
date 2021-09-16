# CMK Encryption Keys
resource "azurerm_key_vault_key" "mysql_encryption_key" {
  name         = "mysql-encryption-key"
  key_vault_id = azurerm_key_vault.keyvault.id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts     = ["unwrapKey", "wrapKey", ]

  depends_on = [
    null_resource.keyvault_admin_group_ra_delay_before_consent,
  ]
}

resource "azurerm_role_assignment" "mysql_kv_role_assignment" {
  scope                = "${azurerm_key_vault.keyvault.id}/keys/${azurerm_key_vault_key.mysql_encryption_key.name}"
  principal_id         = azurerm_mysql_server.mysql.identity.0.principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}


# Allow time for role definition assignment to propagate.
resource "null_resource" "mysql_delay_before_consent" {
  provisioner "local-exec" {
    command     = "${path.module}/scripts/check_rbac_propagation.sh"
    interpreter = ["bash"]
    environment = {
      SCOPE          = "${azurerm_key_vault.keyvault.id}/keys/${azurerm_key_vault_key.mysql_encryption_key.name}"
      PRINCIPAL_ID   = "${azurerm_mysql_server.mysql.identity.0.principal_id}"
      MAX_ITERATIONS = 600
      WAIT_SECONDS   = 2
    }
  }

  depends_on = [
    azurerm_role_assignment.mysql_kv_role_assignment,
  ]
}


# MySQL Server
resource "random_password" "mysql_pw" {
  length      = 32
  special     = false
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}

resource "azurerm_key_vault_secret" "mysql_pw" {
  key_vault_id = azurerm_key_vault.keyvault.id
  name         = "mysql-pw"
  value        = random_password.mysql_pw.result

  depends_on = [
    azurerm_key_vault.keyvault,
    azurerm_role_assignment.keyvault_admin_group_ra,    # Required for destroy ordering
    azurerm_private_endpoint.keyvault_private_endpoint, # Required for destroy ordering
  ]
}

resource "azurerm_mysql_server" "mysql" {
  name                = "${var.prefix}${var.name}-mysql"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "dgc"
  administrator_login_password = azurerm_key_vault_secret.mysql_pw.value

  sku_name = "GP_Gen5_2"
  version  = "5.7"

  storage_mb        = 5120
  auto_grow_enabled = true

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false

  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_mysql_server_key" "mysql_encryption_key" {
  server_id        = azurerm_mysql_server.mysql.id
  key_vault_key_id = azurerm_key_vault_key.mysql_encryption_key.id

  depends_on = [
    null_resource.mysql_delay_before_consent,
  ]
}

resource "azurerm_private_endpoint" "mysql_private_endpoint" {
  name                = "${var.prefix}${var.name}-mysql-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${var.prefix}${var.name}-mysql-private-endpoint-connection"
    private_connection_resource_id = azurerm_mysql_server.mysql.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_mysql.id]
  }
}

resource "azurerm_user_assigned_identity" "mysql_aadadmin_identity" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  name = "mysql-aadadmin"
}

resource "azurerm_mysql_active_directory_administrator" "mysql_aadadmin" {
  server_name         = azurerm_mysql_server.mysql.name
  resource_group_name = azurerm_resource_group.rg.name
  login               = "mysql-aadadmin"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = azurerm_user_assigned_identity.mysql_aadadmin_identity.client_id
}

# Add Audit Events and Metrics to log_analytics - If log analytics is enabled
resource "azurerm_monitor_diagnostic_setting" "mysql_diagnostic_logs" {
  count                      = var.enable_log_analytics_workspace ? 1 : 0
  name                       = "${var.prefix}${var.name}-mysql-analytics"
  target_resource_id         = azurerm_mysql_server.mysql.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id

  log {
    category = "MySqlAuditLogs"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "MySqlSlowLogs"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  lifecycle {
    ignore_changes = [log, metric]
  }

}
