output "issuance_web_address" {
  value       = "https://dgca-issuance-web.${module.base_infra.dns_zone_name}"
  description = "The web address where the issuance website can be accessed"
}
output "issuance_service_url" {
  value       = "https://dgca-issuance-service.${module.base_infra.dns_zone_name}"
  description = "The url where the issuance backend can be accessed"
}
output "businessrule_service_url" {
  value       = "https://dgca-businessrule-service.${module.base_infra.dns_zone_name}"
  description = "The url where the business rule backend can be accessed"
}

output "verifier_service_url" {
  value       = "https://dgca-verifier-service.${module.base_infra.dns_zone_name}"
  description = "The url where the verifier service backend can be accessed"
}