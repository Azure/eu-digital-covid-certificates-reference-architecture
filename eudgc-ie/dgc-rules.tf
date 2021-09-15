# Apply County Codes Rule sets to dgc gateway
resource "null_resource" "upsert_rules" {
  provisioner "local-exec" {
    command     = "./scripts/upsert_ruleset.sh"
    interpreter = ["bash"]
    environment = {
      CERTS_DIR    = "${path.module}/../certs"
      DGC_URL      = "https://${local.dgc_gateway_fqdn}/rules"
      COUNTRY_CODE = "IE"
    }
  }
}
