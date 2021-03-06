variable "prefix" {
  type        = string
  description = "Resource Name Prefix. Should be less than 6 chars. This is used to make sure some resource names are globally unique for some azure resources that require unique names (like Key Vault and Azure Container Registries)"
  default     = ""
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

variable "administrator_group_oid" {
  type        = string
  description = "OID of the Group to grant Administrator permissions. This is used to allow access to the deployed AKS cluster for deployments and troubleshooting"
}

variable "jumpbox_ssh_source_address_prefixes" {
  type        = list(string)
  description = "List of network prefixes allowed to SSH to Jumpbox VM"
  default     = []
}

