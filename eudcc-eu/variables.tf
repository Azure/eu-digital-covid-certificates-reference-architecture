variable "prefix" {
  type        = string
  description = "Resource Name Prefix. This should be a unique string for each deployment, and is used to ensure that multiple deployments can be done to the same subscription for development and testing"
  default     = ""
}

variable "generation" {
  type        = number
  description = "Generation number to be appended to certain resource names (e.g. Purge Protected KeyVault's). Changing this value can only be done during a fresh deployment."
  default     = 1
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

variable "ghcr_username" {
  type        = string
  description = "GitHub Container Registry Username"
}

variable "ghcr_password" {
  type        = string
  sensitive   = true
  description = "GitHub Container Registry Password"
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
  default     = "1.1.3-44c8778-azure-0.0.1-5f09fbf"
}

variable "utility_image_tag" {
  type        = string
  description = "Tag of the Utility Image to import"
  default     = "0.0.1-c5b4119"
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

variable "jump_box_identity_file" {
  type        = string
  description = "The RSA Key for the Jump Box, required for remote executing code over SSH"
}

variable "jump_box_identity_user" {
  type        = string
  description = "The User for the Jump Box to authenticate, required for remote executing code over SSH"
}

variable "jump_box_identity_host" {
  type        = string
  description = "The Host address for the Jump Box, required for remote executing code over SSH"
}
