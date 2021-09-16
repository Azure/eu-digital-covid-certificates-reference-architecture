variable "prefix" {
  type        = string
  description = "Prefix"
}

variable "name" {
  type        = string
  description = "Environment Name"
}

variable "location" {
  type        = string
  description = "Location Name"
}

variable "dev_vnet_rg_name" {
  type        = string
  description = "Dev VNet RG Name"
}

variable "dev_vnet_id" {
  type        = string
  description = "Dev VNet ID"
}

variable "dev_vnet_name" {
  type        = string
  description = "Dev VNet Name"
}

variable "parent_dns_zone_name" {
  type        = string
  description = "Parent DNS Zone Name"
}

variable "parent_dns_zone_rg_name" {
  type        = string
  description = "Parent DNS Zone Resource Group Name"
}

variable "administrator_group_oid" {
  type        = string
  description = "OID of the Group to grant Administrator permissions"
}

variable "acr_imports" {
  type        = map(any)
  description = "Map of ACR Imports to perform"
  default     = {}
}

variable "aad_pod_identity_chart_version" {
  default = "4.1.1"
}

variable "aad_pod_identity_image_tag" {
  default = "v1.8.0"
}

variable "aad_pod_identity_immutable_uamis" {
  type        = list(any)
  description = "A list of immutable UAMI clien IDs for AAD Pod Identity. These IDs, once added to a node, will not be removed"
  default     = []
}

variable "cert_manager_chart_version" {
  default = "1.4.0"
}

variable "cert_manager_image_tag" {
  default = "v1.4.0"
}

variable "external_dns_chart_version" {
  default = "5.1.3"
}

variable "external_dns_image_tag" {
  default = "0.8.0-debian-10-r26"
}

variable "haproxy_ingress_chart_version" {
  default = "v0.13.0-beta.2"
}

variable "haproxy_ingress_image_tag" {
  default = "v0.13.0-beta.2"
}

variable "kube_syslog_sidecar_image_digest" {
  default = "sha256:f948c128ad982b3676269542da1d9e4339f5553a9fc6831b02edf21a667620d9"
}

variable "kube_syslog_sidecar_image_tag" {
  default = "v0.0.1-f948c12"
}

variable "csi_secrets_store_provider_azure_chart_version" {
  default = "0.1.0"
}
variable "azure_key_vault_provider_image_tag" {
  default = "v0.1.0"
}
variable "secrets_store_csi_driver_image_tag" {
  default = "v0.1.0"
}
variable "csi_node_driver_registrar_image_tag" {
  default = "v2.2.0"
}
variable "livenessprobe_csi_driver_image_tag" {
  default = "v2.3.0"
}
variable "secrets_store_driver_crds_image_tag" {
  default = "v0.1.0"
}
variable "enable_log_analytics_workspace" {
  type        = bool
  description = "Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  default     = false
}
variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  type        = string
  default     = "PerGB2018"
}
variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  type        = number
  default     = 30
}
variable "log_analytics_cluster_id" {
  type        = bool
  description = "Enable the sending of Azure Log Workspace to Log Analytics Analytics Custer ID supplied"
  default     = null
}