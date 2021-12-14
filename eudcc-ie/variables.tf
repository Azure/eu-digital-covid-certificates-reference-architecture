variable "prefix" {
  type        = string
  description = "Resource Name Prefix. Should be less than 6 chars. This is used to make sure some resource names are globally unique for some azure resources that require unique names (like Key Vault and Azure Container Registries)"
  default     = ""
}

variable "generation" {
  type        = number
  description = "Generation number to be appended to certain resource names (e.g. Purge Protected Key Vault's). Changing this value can only be done during a fresh deployment."
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
  description = "OID of the Group to grant Administrator permissions. This is used to allow access to the jumpboxes for deployments and troubleshooting"
}

variable "issuance_service_version" {
  type        = string
  description = "Version Number of the Issuance Service"
  default     = "1.0.5-7408b55-azure-0.0.1-1293959"
}

variable "issuance_web_version" {
  type        = string
  description = "Version Number of the Issuance Web"
  default     = "1.1.2-45daa28-azure-0.0.1-1293959"
}

variable "businessrule_service_version" {
  type        = string
  description = "Version Number of the Business Rules Service"
  default     = "1.1.2-b0be8f4-azure-0.0.1-1293959"
}

variable "verifier_service_version" {
  type        = string
  description = "Version Number of the Verifier Service"
  default     = "1.0.4-5888cb7-azure-0.0.1-1293959"
}

variable "msal_proxy_version" {
  type        = string
  description = "version of the msal docker image to use"
  default     = "latest"
}

variable "nginx_image_tag" {
  type        = string
  description = "Tag of the Nginx Image to import"
  default     = "1.21.1"
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

variable "enable_azure_policy" {
  type        = bool
  description = "Enable the creation of policy_set_definitions and resource_group_policy_assignment or not"
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
