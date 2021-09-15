# Notes

Login to the Jumpbox with:

```
az ssh vm -g eudgc-common -n eudgc-common-jumpbox-vm
```

After logging into the Jumpbox, authenthicate to Azure and AKS:
```
az login
az account set --subscription "AG-AGI-APECOE-DEV1"
az aks get-credentials -n eudgc-common-aks -g eudgc-common
kubectl get pods --all-namespaces
```
