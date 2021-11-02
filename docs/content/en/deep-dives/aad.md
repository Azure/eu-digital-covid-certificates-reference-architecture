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

Within Azure Kubernetes Service (AKS), (AAD Pod Identity)[https://github.com/Azure/aad-pod-identity#readme] creates identities and bindings as Kubernetes primitives that allow pods to access
Azure resources that authenticates AAD as an identity provider.

This reference architecture uses AAD Pod-Identity on all service containers.

All service containers' managed identities, within Key Vault their role level will be the minimum scoped access to read the required secret,
key or cert, as [Key Vault has RBAC enabled]({{< relref "key-vault" >}}) which allows the ability to have greater granularity in restricting access.

### AAD authentication for Azure Database for MySQL {id="mysql"}

Authentication to Databases' with static passwords or shared credentials stored in internal systems may be a security and privacy risk,
as credentials may become exposed due to over sharing the passwords to other parties or not being having a short rotation policy.

This reference architecture implements AAD authentication for MySQL on all the architecture's MySQL servers which enable the ability for authentication
via short life tokens instead of passwords for applications connecting to Azure Database for MySQL.

### AAD authentication for Web Authentication

The verification and the authentication of users who have the correct authority to create a certificate on an issuing service is paramount,
straightening the issuing web service with AAD allowing the ability for Organization level access levels and User and Groups policies.

Web Authentication to the certificate issuing service with AAD is documented in detail in the
[Deployment Section]({{< relref "web-authentication" >}}) of the documentation.
