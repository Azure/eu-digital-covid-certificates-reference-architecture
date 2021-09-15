# Deploy Secrets Store CSI Driver and the Azure Keyvault Provider
resource "helm_release" "csi_secrets_store_provider" {
  name       = "csi"
  repository = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  chart      = "csi-secrets-store-provider-azure"
  version    = var.csi_secrets_store_provider_azure_chart_version
  wait       = true
  namespace  = "kube-system"

  values = [
    jsonencode({
      "linux" = {
        "image" = {
          "repository" = "${azurerm_container_registry.acr.login_server}/mcr.microsoft.com/oss/azure/secrets-store/provider-azure"
          "tag"        = var.azure_key_vault_provider_image_tag
        }
      }
      "secrets-store-csi-driver" = {
        "linux" = {
          "image" = {
            "repository" = "${azurerm_container_registry.acr.login_server}/mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver"
            "tag"        = var.secrets_store_csi_driver_image_tag
          }
          "registrarImage" = {
            "repository" = "${azurerm_container_registry.acr.login_server}/mcr.microsoft.com/oss/kubernetes-csi/csi-node-driver-registrar"
            "tag"        = var.csi_node_driver_registrar_image_tag
          }
          "livenessProbeImage" = {
            "repository" = "${azurerm_container_registry.acr.login_server}/mcr.microsoft.com/oss/kubernetes-csi/livenessprobe"
            "tag"        = var.livenessprobe_csi_driver_image_tag
          }
          "crds" = {
            "image" = {
              "repository" = "${azurerm_container_registry.acr.login_server}/mcr.microsoft.com/oss/kubernetes-csi/secrets-store/driver-crds"
              "tag"        = var.secrets_store_driver_crds_image_tag
            }
          }
        }
        "syncSecret" = {
          "enabled" = "true"
        }
      }
    })
  ]

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    null_resource.import-image["secrets-store-csi-driver"],
    null_resource.import-image["secrets-store-csi-driver-crds"],
    null_resource.import-image["azure-key-vault-provider"],
    null_resource.import-image["livenessprobe-csi-driver"],
    null_resource.import-image["csi_node_driver_registrar"],
  ]
}
