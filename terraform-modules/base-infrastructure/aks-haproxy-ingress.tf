# Public IP Address for Ingress
resource "azurerm_public_ip" "haproxy_ingress_pip" {
  name                = "${var.prefix}${var.name}-haproxy-ingress-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Namespace
resource "kubernetes_namespace" "haproxy_ingress" {
  metadata {
    name = "haproxy-ingress"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
  ]
}

# Deploy HAProxy Ingress
resource "helm_release" "haproxy_ingress" {
  name       = "haproxy-ingress"
  repository = "https://haproxy-ingress.github.io/charts"
  chart      = "haproxy-ingress"
  version    = var.haproxy_ingress_chart_version
  wait       = true
  namespace  = "haproxy-ingress"

  values = [
    jsonencode({
      "controller" = {
        "image" = {
          "repository" = "${azurerm_container_registry.acr.login_server}/jcmoraisjr/haproxy-ingress"
          "tag"        = var.haproxy_ingress_image_tag
        }

        "logs" = {
          "enabled" = "true"
          "image" = {
            "repository" = "${azurerm_container_registry.acr.login_server}/whereisaaron/kube-syslog-sidecar"
            "tag"        = var.kube_syslog_sidecar_image_tag
          }
        }

        "extraArgs" = {
          "publish-service" = "haproxy-ingress/haproxy-ingress"
        }

        "service" = {
          "loadBalancerIP" = azurerm_public_ip.haproxy_ingress_pip.ip_address
        }
      }
    })
  ]

  depends_on = [
    azurerm_public_ip.haproxy_ingress_pip,
    kubernetes_namespace.haproxy_ingress,
    null_resource.import-image["haproxy-ingress-controller"],
    null_resource.import-image["kube-syslog-sidecar"],
  ]
}

# NSG Rules
resource "azurerm_network_security_rule" "haproxy_ingress_allow_https" {
  name                        = "${var.prefix}${var.name}-allow-https"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "TCP"

  source_port_range     = "*"
  source_address_prefix = "Internet"

  destination_port_range     = "443"
  destination_address_prefix = azurerm_public_ip.haproxy_ingress_pip.ip_address

  depends_on = [
    helm_release.haproxy_ingress,
  ]
}

resource "azurerm_network_security_rule" "haproxy_ingress_allow_http" {
  name                        = "${var.prefix}${var.name}-allow-http"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  priority  = 101
  direction = "Inbound"
  access    = "Allow"
  protocol  = "TCP"

  source_port_range     = "*"
  source_address_prefix = "Internet"

  destination_port_range     = "80"
  destination_address_prefix = azurerm_public_ip.haproxy_ingress_pip.ip_address

  depends_on = [
    helm_release.haproxy_ingress,
  ]
}
