# Namespace
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
  ]
}

# Deploy Cert Manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_chart_version
  wait       = true
  namespace  = "cert-manager"

  values = [
    jsonencode({
      "image" = {
        "repository" = "${azurerm_container_registry.acr.login_server}/jetstack/cert-manager-controller"
        "tag"        = var.cert_manager_image_tag
      }

      "webhook" = {
        "image" = {
          "repository" = "${azurerm_container_registry.acr.login_server}/jetstack/cert-manager-webhook"
          "tag"        = var.cert_manager_image_tag
        }
      }

      "cainjector" = {
        "image" = {
          "repository" = "${azurerm_container_registry.acr.login_server}/jetstack/cert-manager-cainjector"
          "tag"        = var.cert_manager_image_tag
        }
      }

      "installCRDs" = "true"

      "extraArgs" = [
        "--acme-http01-solver-image=${azurerm_container_registry.acr.login_server}/jetstack/cert-manager-acmesolver:${var.cert_manager_image_tag}"
      ]
    })
  ]

  depends_on = [
    kubernetes_namespace.cert_manager,
    null_resource.import-image["cert-manager-controller"],
    null_resource.import-image["cert-manager-cainjector"],
    null_resource.import-image["cert-manager-webhook"],
    null_resource.import-image["cert-manager-acmesolver"],
  ]
}

resource "kubectl_manifest" "cert_manager_clusterissuer_letsencrypt" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: letsencrypt-issuer-account-key
    solvers:
    - http01:
        ingress:
          class: haproxy
YAML

  depends_on = [
    helm_release.cert_manager,
  ]
}
