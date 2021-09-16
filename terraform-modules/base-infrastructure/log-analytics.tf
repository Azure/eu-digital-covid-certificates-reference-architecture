# Azure Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  count               = var.enable_log_analytics_workspace ? 1 : 0
  name                = "${var.prefix}${var.name}-log-analytics-workspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days
}

# Azure Log Analytics solution for ContainerInsights
resource "azurerm_log_analytics_solution" "container_insights" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

# Azure Log Analytics solution for KeyVaultAnalytics
resource "azurerm_log_analytics_solution" "key_vault_analytics" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "KeyVaultAnalytics"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/KeyVaultAnalytics"
  }
}

# Azure Log Analytics solution for SQLAssessmentPlus
resource "azurerm_log_analytics_solution" "sql_assessment_plus" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "SQLAssessmentPlus"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SQLAssessmentPlus"
  }
}

# Azure Log Analytics solution for SecurityInsights
resource "azurerm_log_analytics_solution" "security_insights" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

# Azure Log Analytics solution for NetworkMonitoring
resource "azurerm_log_analytics_solution" "network_monitoring" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "NetworkMonitoring"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/NetworkMonitoring"
  }
}

# Azure Log Analytics solution for ServiceMap
resource "azurerm_log_analytics_solution" "service_map" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "ServiceMap"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ServiceMap"
  }
}

# Azure Log Analytics solution for AntiMalware
resource "azurerm_log_analytics_solution" "anti_malware" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "AntiMalware"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/AntiMalware"
  }
}

# Azure Log Analytics solution for AzureActivity
resource "azurerm_log_analytics_solution" "azure_activity" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "AzureActivity"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/AzureActivity"
  }
}

# Azure Log Analytics solution for ChangeTracking
resource "azurerm_log_analytics_solution" "change_tracking" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "ChangeTracking"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ChangeTracking"
  }
}

# Azure Log Analytics solution for Updates
resource "azurerm_log_analytics_solution" "updates" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "Updates"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}

locals {
  # note: putting [*] behind a single value will create a list (if it is null then it will be an empty list)
  log_analytics_cluster_id = var.log_analytics_cluster_id[*]
}

# Link AKS Log Analytics Workspace to Log Analytics Cluster
resource "azurerm_log_analytics_linked_service" "log_analytics_linked_service" {
  count               = var.enable_log_analytics_workspace ? 1 : 0 && count(local.log_analytics_cluster_id)
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  write_access_id     = local.log_analytics_cluster_id[0]

  depends_on = [
    azurerm_log_analytics_solution.container_insights,
    azurerm_log_analytics_solution.key_vault_analytics,
    azurerm_log_analytics_solution.sql_assessment_plus,
    azurerm_log_analytics_solution.security_insights,
    azurerm_log_analytics_solution.network_monitoring,
    azurerm_log_analytics_solution.service_map,
    azurerm_log_analytics_solution.anti_malware,
    azurerm_log_analytics_solution.azure_activity,
    azurerm_log_analytics_solution.change_tracking,
    azurerm_log_analytics_solution.updates,
    azurerm_monitor_diagnostic_setting.keyvault_diagnostic_logs,
    azurerm_monitor_diagnostic_setting.acr_diagnostic_logs,
    azurerm_monitor_diagnostic_setting.mysql_diagnostic_logs,
  ]
}