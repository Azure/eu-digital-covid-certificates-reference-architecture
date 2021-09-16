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
  description = "OID of the Group to grant Administrator permissions"
}

variable "gateway_version" {
  type        = string
  description = "Version Number of the Gateway"
  default     = "79"
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
  type        = bool
  description = "Enable the sending of Azure Log Workspace to Log Analytics Analytics Custer ID supplied"
  default     = null
}