#!/bin/bash

set -euo pipefail

# Wait for dpkg lock to become free
while ( fuser /var/lib/dpkg/lock >/dev/null 2>&1 ); do
    sleep 5
done

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install K8S CLI
sudo az aks install-cli --client-version v1.19.11
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl

# Install Helm CLI
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo bash

# Install MySQL & PostgreSQL Clients
sudo apt-get install --yes mysql-client postgresql-client-12
