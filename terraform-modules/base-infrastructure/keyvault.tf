# KeyVault
resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.prefix}${var.name}-keyvault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  enable_rbac_authorization   = true

  sku_name = "premium"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = []
  }

  depends_on = [
    azurerm_virtual_network_peering.from-dev,
    azurerm_virtual_network_peering.to-dev,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_keyvault_link,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_keyvault_link_dev,
  ]
}

# Grant Admin Group access to KeyVault
resource "azurerm_role_assignment" "keyvault_admin_group_ra" {
  scope                = azurerm_key_vault.keyvault.id
  principal_id         = var.administrator_group_oid
  role_definition_name = "Key Vault Administrator"
}

# Allow time for role definition assignment to propagate.
resource "null_resource" "keyvault_admin_group_ra_delay_before_consent" {
  provisioner "local-exec" {
    command     = "${path.module}/scripts/check_rbac_propagation.sh"
    interpreter = ["bash"]
    environment = {
      SCOPE          = "${azurerm_key_vault.keyvault.id}"
      PRINCIPAL_ID   = "${var.administrator_group_oid}"
      MAX_ITERATIONS = 600
      WAIT_SECONDS   = 2
    }
  }

  depends_on = [
    azurerm_role_assignment.keyvault_admin_group_ra,
    null_resource.keyvault_private_endpoint_delay_before_consent,
  ]
}


# KeyVault Private Link
resource "azurerm_private_endpoint" "keyvault_private_endpoint" {
  name                = "${var.prefix}${var.name}-keyvault-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${var.prefix}${var.name}-keyvault-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_keyvault.id]
  }
}

# Add Audit Events and Metrics to log_analytics - If log analytics is enabled
resource "azurerm_monitor_diagnostic_setting" "keyvault_diagnostic_logs" {
  count                          = var.enable_log_analytics_workspace ? 1 : 0
  name                           = "${var.prefix}${var.name}-keyvault-analytics"
  target_resource_id             = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  log_analytics_destination_type = "Dedicated"
  log {
    category = "AuditEvent"
    enabled  = true

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

# Allow time for dns record to apply.
resource "null_resource" "keyvault_private_endpoint_delay_before_consent" {
  provisioner "file" {
    source      = "${path.module}/scripts/check_dns_propagation.sh"
    destination = "/tmp/check_dns_propagation.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/check_dns_propagation.sh",
      "/tmp/check_dns_propagation.sh ${azurerm_private_endpoint.keyvault_private_endpoint.private_dns_zone_configs[0].record_sets[0].fqdn} ${azurerm_private_endpoint.keyvault_private_endpoint.private_service_connection[0].private_ip_address} 600 2",
    ]
  }

  connection {
    agent       = false
    timeout     = "2m"
    type        = "ssh"
    host        = var.jump_box_identity_host
    user        = var.jump_box_identity_user
    certificate = file("${var.jump_box_identity_file}.pub-aadcert.pub")
    private_key = file("${var.jump_box_identity_file}")
  }

  depends_on = [
    azurerm_private_endpoint.keyvault_private_endpoint,
  ]
}