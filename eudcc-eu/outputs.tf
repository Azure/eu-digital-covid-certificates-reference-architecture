output "dgc_gateway_fqdn" {
  value       = "dgc-gateway.${module.base_infra.dns_zone_name}"
  description = "The fqdn for the EU DGC Gateway used by the per member country deployments"
}
