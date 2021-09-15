# Grant AKS access necessary for AAD Pod Identity
resource "azurerm_role_assignment" "aks_mio" {
  scope                = azurerm_resource_group.rg.id
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "Managed Identity Operator"
}

resource "azurerm_role_assignment" "aks_managed_rg_mio" {
  scope                = data.azurerm_resource_group.aks_managed_rg.id
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "Managed Identity Operator"
}

resource "azurerm_role_assignment" "aks_managed_rg_vmc" {
  scope                = data.azurerm_resource_group.aks_managed_rg.id
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "Virtual Machine Contributor"
}

# Namespace
resource "kubernetes_namespace" "aad_pod_identity" {
  metadata {
    name = "aad-pod-identity"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
  ]
}

# Deploy AAD Pod Identity
resource "helm_release" "aad_pod_identity" {
  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = var.aad_pod_identity_chart_version
  wait       = true
  namespace  = "aad-pod-identity"

  values = [
    jsonencode({
      "image" = {
        "repository" = "${azurerm_container_registry.acr.login_server}/azure/aad-pod-identity"
      }

      "mic" = {
        "tag" = var.aad_pod_identity_image_tag
      }

      "nmi" = {
        "tag" = var.aad_pod_identity_image_tag
      }

      "immutableUserMSIs" = concat(var.aad_pod_identity_immutable_uamis, [
        azurerm_user_assigned_identity.mysql_aadadmin_identity.client_id,
        azurerm_user_assigned_identity.external_dns_identity.client_id,
      ])
    })
  ]

  depends_on = [
    kubernetes_namespace.aad_pod_identity,
    azurerm_role_assignment.aks_mio,
    azurerm_role_assignment.aks_managed_rg_mio,
    azurerm_role_assignment.aks_managed_rg_vmc,
    null_resource.import-image["aad-pod-identity"],
  ]
}
