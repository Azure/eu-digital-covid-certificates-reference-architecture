output "issuance_web_address" {
  value       = "https://dgca-issuance-web.${module.base_infra.dns_zone_name}"
  description = "The web address where the issueance website can be accessed"
}