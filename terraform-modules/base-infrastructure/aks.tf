# AKS User Assigned Identity
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${var.prefix}${var.name}-aks-identity"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "aks_identity_dns_contributer" {
  scope                = azurerm_private_dns_zone.private_dns_zone_aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}


# AKS CMK Keys
resource "azurerm_key_vault_key" "aks_encryption_key" {
  name         = "aks-encryption-key"
  key_vault_id = azurerm_key_vault.keyvault.id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts     = ["unwrapKey", "wrapKey", ]

  depends_on = [
    azurerm_key_vault.keyvault,
    null_resource.keyvault_admin_group_ra_delay_before_consent,
    azurerm_role_assignment.keyvault_admin_group_ra,    # Required for destroy ordering
    azurerm_private_endpoint.keyvault_private_endpoint, # Required for destroy ordering
  ]
}

resource "azurerm_disk_encryption_set" "aks_encryption_set" {
  name                = "aks-encryption-set"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.aks_encryption_key.id

  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_role_assignment" "aks_encryption_set" {
  scope                = "${azurerm_key_vault.keyvault.id}/keys/${azurerm_key_vault_key.aks_encryption_key.name}"
  principal_id         = azurerm_disk_encryption_set.aks_encryption_set.identity.0.principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}

# Allow time for role definition assignment to propagate.
resource "null_resource" "aks_delay_before_consent" {
  provisioner "local-exec" {
    command     = "${path.module}/scripts/check_rbac_propagation.sh"
    interpreter = ["bash"]
    environment = {
      SCOPE          = "${azurerm_key_vault.keyvault.id}/keys/${azurerm_key_vault_key.aks_encryption_key.name}"
      PRINCIPAL_ID   = "${azurerm_disk_encryption_set.aks_encryption_set.identity.0.principal_id}"
      MAX_ITERATIONS = 600
      WAIT_SECONDS   = 2
    }
  }

  depends_on = [
    azurerm_role_assignment.aks_encryption_set,
  ]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}${var.name}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}${var.name}-aks"

  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.private_dns_zone_aks.id

  disk_encryption_set_id = azurerm_disk_encryption_set.aks_encryption_set.id

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  default_node_pool {
    name                   = "default"
    min_count              = 2
    max_count              = 5
    enable_auto_scaling    = true
    enable_host_encryption = true
    vm_size                = "Standard_DS2_v2"
    vnet_subnet_id         = azurerm_subnet.subnet.id
  }

  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity.id
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed = true
      admin_group_object_ids = [
        var.administrator_group_oid
      ]
    }
  }

  addon_profile {
    azure_policy {
      enabled = true
    }

    aci_connector_linux {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    ingress_application_gateway {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled                    = var.enable_log_analytics_workspace
      log_analytics_workspace_id = var.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.log_analytics_workspace[0].id : null
    }
  }

  depends_on = [
    azurerm_role_assignment.aks_identity_dns_contributer, # Required to ensure destroy ordering is correct per the TF docs.
    azurerm_virtual_network_peering.from-dev,
    azurerm_virtual_network_peering.to-dev,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_aks_link,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_aks_link_dev,
    null_resource.aks_delay_before_consent,
  ]
}

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.acr.id
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
}

# Gather AKS's Managed RG Info
data "azurerm_resource_group" "aks_managed_rg" {
  name = azurerm_kubernetes_cluster.aks.node_resource_group
}

# Deploy built in "Kubernetes cluster pod security baseline standards for Linux-based workloads" Initiative
resource "azurerm_resource_group_policy_assignment" "aks_baseline_policy" {
  name                 = "${var.prefix}${var.name}-aks-baseline-policy"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/a8640138-9b0a-4a28-b8cb-1666c838647d"

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "deny"
  },
  "excludedNamespaces": {
    "value": [
      "kube-system",
      "gatekeeper-system",
      "aad-pod-identity"
    ]
  }
}
PARAMETERS
}

# Deploy built in "Kubernetes cluster containers should only use allowed images" Policy
resource "azurerm_resource_group_policy_assignment" "aks_acr_policy" {
  name                 = "${var.prefix}${var.name}-aks-acr-policy"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469"

  parameters = <<PARAMETERS
{
  "allowedContainerImagesRegex": {
    "value": "^${azurerm_container_registry.acr.login_server}/.+$"
  }
}
PARAMETERS
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host = "https://${azurerm_kubernetes_cluster.aks.private_fqdn}:443/"

  username               = azurerm_kubernetes_cluster.aks.kube_admin_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_admin_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate)
}

# Configure the Helm Provider
provider "helm" {
  kubernetes {
    host = "https://${azurerm_kubernetes_cluster.aks.private_fqdn}:443/"

    username               = azurerm_kubernetes_cluster.aks.kube_admin_config.0.username
    password               = azurerm_kubernetes_cluster.aks.kube_admin_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate)
  }
}

# Configure the Kubectl Provider
provider "kubectl" {
  host = "https://${azurerm_kubernetes_cluster.aks.private_fqdn}:443/"

  load_config_file       = false
  username               = azurerm_kubernetes_cluster.aks.kube_admin_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_admin_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate)
}
