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

variable "administrator_group_oid" {
  type        = string
  description = "OID of the Group to grant Administrator permissions"
}

variable "jumpbox_ssh_source_address_prefixes" {
  type        = list(string)
  description = "List of prefixes allowed to SSH to Jumpbox VM"
}
