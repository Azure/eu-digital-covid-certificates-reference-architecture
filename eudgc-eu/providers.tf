# Configure the Kubernetes Provider
provider "kubernetes" {
  host = "https://${module.base_infra.aks_private_fqdn}:443"

  username               = module.base_infra.aks_username
  password               = module.base_infra.aks_password
  client_certificate     = base64decode(module.base_infra.aks_client_certificate)
  client_key             = base64decode(module.base_infra.aks_client_key)
  cluster_ca_certificate = base64decode(module.base_infra.aks_cluster_ca_certificate)
}

# Configure the Helm Provider
provider "helm" {
  kubernetes {
    host = "https://${module.base_infra.aks_private_fqdn}:443"

    username               = module.base_infra.aks_username
    password               = module.base_infra.aks_password
    client_certificate     = base64decode(module.base_infra.aks_client_certificate)
    client_key             = base64decode(module.base_infra.aks_client_key)
    cluster_ca_certificate = base64decode(module.base_infra.aks_cluster_ca_certificate)
  }
}

# Configure the Kubectl Provider
provider "kubectl" {
  host = "https://${module.base_infra.aks_private_fqdn}:443"

  load_config_file       = false
  username               = module.base_infra.aks_username
  password               = module.base_infra.aks_password
  client_certificate     = base64decode(module.base_infra.aks_client_certificate)
  client_key             = base64decode(module.base_infra.aks_client_key)
  cluster_ca_certificate = base64decode(module.base_infra.aks_cluster_ca_certificate)
}
