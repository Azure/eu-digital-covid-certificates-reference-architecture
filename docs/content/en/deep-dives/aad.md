---
title: "AAD authentication"
linkTitle: "AAD"
weight: 50
description: >
    Deep Dive into AAD authentication
---

## Azure Active Directory (AAD) Authentication

This reference architecture utilises Azure Active Directory (AAD) for Authentication where possible to do so.
Fortifying the integrity of the whole system by removing stored passwords. User accounts and [Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) are used through and reference architecture in place of passwords.

### AAD authentication for Azure Kubernetes Service

Within Azure Kubernetes Service (AKS), [AAD Pod Identity](https://github.com/Azure/aad-pod-identity#readme) enables Kubernetes applications to access cloud resources securely with Azure Active Directory.

Using Kubernetes primitives, administrators configure identities and bindings to match pods. Then without any code modifications, your containerized applications can leverage any resource in the cloud that depends on AAD as an identity provider.

This reference architecture uses AAD Pod Identity on all AKS Pods.

Each AKS Pod has a managed identity which has been granted least privilege rights to the resources it consumes, for example, single secret RBAC grants within [Key Vault]({{< relref "aad#key-vault" >}}) or single database access within [Azure Database for MySQL]({{< relref "aad#mysql" >}}).

### AAD authentication for Key Vault {id="key-vault"}

Key Vault is configured to use RBAC based on AAD, please refer to the [Key Vault]({{< relref "key-vault" >}}) section for more information.

### AAD authentication for Azure Database for MySQL {id="mysql"}

Authentication to Databases' with static passwords or shared credentials stored in internal systems may be a security and privacy risk,
as credentials may become exposed due to over sharing the passwords to other parties or not being having a short rotation policy.

This reference architecture implements AAD authentication for MySQL on all deployed MySQL servers which enables authentication
via short life tokens instead of passwords for applications connecting to Azure Database for MySQL.

### AAD authentication for Web Authentication

The verification and the authentication of users who have the correct authority to create a certificate on an issuing service is paramount,
straightening the issuing web service with AAD allowing the ability for Organization level access levels and User and Groups policies.

Web Authentication to the certificate issuing service with AAD is documented in detail in the
[Deployment Section]({{< relref "web-authentication" >}}) of the documentation.


Read about [Log Analytics]({{< relref "log-analytics.md" >}}) in the next section.
