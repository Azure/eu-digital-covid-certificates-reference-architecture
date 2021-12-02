---
title: "Validation"
linkTitle: "Validation"
weight: 50
description: >
    Validation the deployment of the EU Digital Green Certificate Reference Architecture
---

## Issue a Certificate

### Navigate to the Issuance Web Portal

Issuing a Vaccine, Test or Recovery Certificate will validate that most of the components are up and running successfully, so this shoud be the first validation performed.

Open the Issuance Web Portal in your web browser by opening the following URL, replacing the two placeholders with the matching values from your `terraform.tfvars` file:

```
https://dgca-issusance-web.eudcc-ie.<prefix>.<parent_dns_zone_name>/
```

For example, the complete URL would be `https://dgca-issusance-web.eudcc-ie.tst.contoso.com/` if your `terraform.tfvars` had the following options:

```terraform
prefix               = "tst"
parent_dns_zone_name = "contoso.com"
```

### Login to the Issuance Portal

Once you have determined the URL of the Issuance Web Portal and visted the URL in your browser, you will be presented with a login screen. Please login using your Azure Active Directory credentials.

![Issuance Portal Login](/screenshots/login-form.png 'Login Form')

Once logged in, the Issuance Web Portal homepage should be presented:

![Issuance Portal Home](/screenshots/issuance-portal-home.png 'Issuance Portal Home')

### Issue a Vaccination Certificate

Choose the `Record Vaccination Certification` option, complete the required form fields, and choose `Next`  to submit:

![Issuance Portal Form](/screenshots/issuance-portal-form.png 'Issuance Portal Form')

Once submitted, you will be presented with the Vaccine Certificate:

![Issuance Portal Certificate](/screenshots/issuance-portal-certificate.png 'Issuance Portal Certificate')

### Import the Certificate into the Wallet Android App

TODO..

### Verify a Certificate using the Verifier Android App

TODO..

## Individual Component Validations

### SSH to EU or IE Jumpboxes

During the creation of the `eudgc-dev` terraform stack, a Jumpbox is created for each of the EU and IE stacks, allowing secure access the Azure resources deployed. To SSH into these Jumpboxes, you can use the Azure CLI SSH extention which is preinsalled in the Codespace and DevContainer.

| Stack | Command                                            |
| ----- | -------------------------------------------------- |
| EU    | `az ssh vm -g eudcc-eu -n eudcc-eu-dev-jumpbox-vm` |
| IE    | `az ssh vm -g eudcc-ie -n eudcc-ie-dev-jumpbox-vm` |

### Access AKS

Begin by SSHing to the approperiate EU or IE Jumpbox, and the proceed with the steps below.

#### Login to Azure CLI

Start by logging into the Azure CLI, and selecting the correct subscription:

```bash
$ az login
$ az account set -s <subscription_id>
```

#### Login and Inspect the AKS Cluster

Next, login to the AKS Cluster:

```bash
$ az aks get-credentials -g eudcc-eu -n eudcc-eu-aks
$ kubectl get pods --all-namespaces
```

> __Calls to Action__
>
>Read about [web authentication]({{< relref "web-authentication.md" >}}) in the next section.
