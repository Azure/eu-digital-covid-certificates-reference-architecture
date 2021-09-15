# ACR
resource "azurerm_container_registry" "acr" {
  name                          = "${var.prefix}${replace(var.name, "-", "")}acr"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  depends_on = [
    azurerm_virtual_network_peering.from-dev,
    azurerm_virtual_network_peering.to-dev,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_acr_link,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_acr_link_dev,
  ]
}

# ACR Private Link
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "${var.prefix}${replace(var.name, "-", "")}acr-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${var.prefix}${replace(var.name, "-", "")}acr-private-endpoint-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_acr.id]
  }
}

# Import Images into ACR
locals {
  acr_imports = merge(var.acr_imports, {
    aad-pod-identity-mic = {
      source      = "mcr.microsoft.com/oss/azure/aad-pod-identity/mic:${var.aad_pod_identity_image_tag}"
      destination = "azure/aad-pod-identity/mic:${var.aad_pod_identity_image_tag}"
    }
    aad-pod-identity-nmi = {
      source      = "mcr.microsoft.com/oss/azure/aad-pod-identity/nmi:${var.aad_pod_identity_image_tag}"
      destination = "azure/aad-pod-identity/nmi:${var.aad_pod_identity_image_tag}"
    }
    cert-manager-controller = {
      source      = "quay.io/jetstack/cert-manager-controller:${var.cert_manager_image_tag}"
      destination = "jetstack/cert-manager-controller:${var.cert_manager_image_tag}"
    }
    cert-manager-cainjector = {
      source      = "quay.io/jetstack/cert-manager-cainjector:${var.cert_manager_image_tag}"
      destination = "jetstack/cert-manager-cainjector:${var.cert_manager_image_tag}"
    }
    cert-manager-webhook = {
      source      = "quay.io/jetstack/cert-manager-webhook:${var.cert_manager_image_tag}"
      destination = "jetstack/cert-manager-webhook:${var.cert_manager_image_tag}"
    }
    cert-manager-acmesolver = {
      source      = "quay.io/jetstack/cert-manager-acmesolver:${var.cert_manager_image_tag}"
      destination = "jetstack/cert-manager-acmesolver:${var.cert_manager_image_tag}"
    }
    external-dns = {
      source      = "docker.io/bitnami/external-dns:${var.external_dns_image_tag}"
      destination = "bitnami/external-dns:${var.external_dns_image_tag}"
    }
    haproxy-ingress-controller = {
      source      = "quay.io/jcmoraisjr/haproxy-ingress:${var.haproxy_ingress_image_tag}"
      destination = "jcmoraisjr/haproxy-ingress:${var.haproxy_ingress_image_tag}"
    }
    kube-syslog-sidecar = {
      # Used by HAProxy Ingress Chart
      source      = "docker.io/whereisaaron/kube-syslog-sidecar@${var.kube_syslog_sidecar_image_digest}"
      destination = "whereisaaron/kube-syslog-sidecar:${var.kube_syslog_sidecar_image_tag}"
    }
    secrets-store-csi-driver = {
      source      = "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver:${var.secrets_store_csi_driver_image_tag}"
      destination = "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver:${var.secrets_store_csi_driver_image_tag}"
    }
    secrets-store-csi-driver-crds = {
      source      = "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver-crds:${var.secrets_store_driver_crds_image_tag}"
      destination = "mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver-crds:${var.secrets_store_driver_crds_image_tag}"
    }
    azure-key-vault-provider = {
      source      = "mcr.microsoft.com/oss/azure/secrets-store/provider-azure:${var.azure_key_vault_provider_image_tag}"
      destination = "mcr.microsoft.com/oss/azure/secrets-store/provider-azure:${var.azure_key_vault_provider_image_tag}"
    }
    livenessprobe-csi-driver = {
      source      = "mcr.microsoft.com/oss/kubernetes-csi/livenessprobe:${var.livenessprobe_csi_driver_image_tag}"
      destination = "mcr.microsoft.com/oss/kubernetes-csi/livenessprobe:${var.livenessprobe_csi_driver_image_tag}"
    }
    csi_node_driver_registrar = {
      source      = "mcr.microsoft.com/oss/kubernetes-csi/csi-node-driver-registrar:${var.csi_node_driver_registrar_image_tag}"
      destination = "mcr.microsoft.com/oss/kubernetes-csi/csi-node-driver-registrar:${var.csi_node_driver_registrar_image_tag}"
    }
  })
}

resource "null_resource" "import-image" {
  for_each = local.acr_imports

  triggers = {
    source      = each.value.source
    destination = each.value.destination
  }

  provisioner "local-exec" {
    command = "az acr import --subscription ${data.azurerm_client_config.current.subscription_id} --force --name ${azurerm_container_registry.acr.name} --source ${each.value.source} --image ${each.value.destination} ${lookup(each.value, "username", "unused") == "unused" ? "" : "--username ${each.value.username}"} ${lookup(each.value, "password", "unused") == "unused" ? "" : "--password ${each.value.password}"}"
  }
}

# Add Audit Events and Metrics to log_analytics - If log analytics is enabled
resource "azurerm_monitor_diagnostic_setting" "acr_diagnostic_logs" {
  count                      = var.enable_log_analytics_workspace ? 1 : 0
  name                       = "${var.prefix}${var.name}-acr-analytics"
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  log {
    category = "ContainerRegistryRepositoryEvents"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "ContainerRegistryLoginEvents"

    retention_policy {
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}
