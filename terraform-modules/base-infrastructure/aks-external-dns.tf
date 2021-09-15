# Create a UAMI for External DNS
resource "azurerm_user_assigned_identity" "external_dns_identity" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  name = "external-dns"
}

# Grant AKS access to DNS Zone - external DNS requires this is granted at the RG level
resource "azurerm_role_assignment" "external_dns_identity_dns_contributor" {
  scope                = azurerm_resource_group.rg.id
  principal_id         = azurerm_user_assigned_identity.external_dns_identity.principal_id
  role_definition_name = "DNS Zone Contributor"
}

# Namespace
resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
  ]
}

resource "kubectl_manifest" "external_dns_azure_identity" {
  yaml_body = <<YAML
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: external-dns
  namespace: external-dns
spec:
  type: 0
  resourceID: "${azurerm_user_assigned_identity.external_dns_identity.id}"
  clientID: "${azurerm_user_assigned_identity.external_dns_identity.client_id}"
YAML

  depends_on = [
    kubernetes_namespace.external_dns,
    azurerm_user_assigned_identity.external_dns_identity,
    azurerm_role_assignment.external_dns_identity_dns_contributor,
    helm_release.aad_pod_identity,
  ]
}

resource "kubectl_manifest" "external_dns_azure_identity_binding" {
  yaml_body = <<YAML
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: external-dns-binding
  namespace: external-dns
spec:
  azureIdentity: external-dns
  selector: external-dns
YAML

  depends_on = [
    kubernetes_namespace.external_dns,
    helm_release.aad_pod_identity,
    kubectl_manifest.external_dns_azure_identity,
  ]
}

# Deploy External DNS
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_chart_version
  wait       = true
  namespace  = "external-dns"

  values = [
    jsonencode({
      "image" = {
        "registry"   = azurerm_container_registry.acr.login_server
        "repository" = "bitnami/external-dns"
        "tag"        = var.external_dns_image_tag
      }

      "provider" = "azure"

      "azure" = {
        "tenantId"                    = data.azurerm_client_config.current.tenant_id
        "subscriptionId"              = data.azurerm_client_config.current.subscription_id
        "resourceGroup"               = azurerm_resource_group.rg.name
        "useManagedIdentityExtension" = "true"
      }

      "podLabels" = {
        "aadpodidbinding" = "external-dns"
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.external_dns,
    kubectl_manifest.external_dns_azure_identity,
    kubectl_manifest.external_dns_azure_identity_binding,
    null_resource.import-image["external-dns"],
  ]
}
