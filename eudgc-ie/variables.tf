variable "prefix" {
  type        = string
  description = "Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing"
}

variable "location" {
  type        = string
  description = "Location Name"
}

variable "subscription_id" {
  type        = string
  description = "Subscription to deploy into"
}

variable "tenant_id" {
  type        = string
  description = "Tenant to deploy into"
}

variable "acr_username" {
  type        = string
  description = "ACR Username"
}

variable "acr_password" {
  type        = string
  sensitive   = true
  description = "ACR Password"
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
  description = "OID of the Group to grant Administrator permissions. This is used to allow access to the jumpboxes for deployments and troubleshooting"
}

variable "issuance_service_version" {
  type        = string
  description = "Version Number of the Issuance Service"
  default     = "94"
}

variable "issuance_web_version" {
  type        = string
  description = "Version Number of the Issuance Web"
  default     = "90"
}

variable "businessrule_service_version" {
  type        = string
  description = "Version Number of the Business Rules Service"
  default     = "93"
}

variable "verifier_service_version" {
  type        = string
  description = "Version Number of the Verifier Service"
  default     = "95"
}

variable "msal_proxy_version" {
  type        = string
  description = "version of the msal docker image to use"
  default     = "0.0.1"
}

variable "nginx_image_tag" {
  type        = string
  description = "Tag of the Nginx Image to import"
  default     = "1.21.1"
}

variable "utility_image_tag" {
  type        = string
  description = "Tag of the Utility Image to import"
  default     = "3"
}

variable "enable_log_analytics_workspace" {
  type        = bool
  description = "Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  default     = false
}

variable "log_analytics_cluster_id" {
  type        = string
  description = "Enable the sending of Azure Log Workspace to Log Analytics Analytics Custer ID supplied"
  default     = null
}
