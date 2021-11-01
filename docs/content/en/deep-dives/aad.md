---
title: "AAD authentication"
linkTitle: "AAD"
weight: 50
description: >
    Deep Dive into AAD authentication
---

## Azure Active Directory (AAD) Authentication

This reference architecture utilises Azure Active Directory (AAD) for Authentication where possible to do so.
Fortifying the integrity of the whole system by removing stored passwords used for authentication for database connections.
it is also utilised to create managed identities and bindings in Kubernetes in pod level pod-managed identities of AKS,
allowing pod authentication to resources that rely on AAD as an identity provider.

Web Authentication to the certificate issuing service with AAD is documented in detail in the
[Deployment Section](docs/content/en/deployment/web-authentication.md) of the documentation.

### AAD authentication for Azure Kubernetes Service

Within Azure Kubernetes Service (AKS), Pod-Identity creates identities and bindings as Kubernetes primitives that allow pods to access
Azure resources that authenticates AAD as an identity provider.

This reference architecture uses AAD Pod-Identity all eu-digital-green-certificates service contianers, will be the role level "`Key Vault Secrets User`" which Key Vault will reference the service for only relavent sectect with Key vault and RBAC support see [HERE](docs/content/en/deep-dives/keyvault.md).

### AAD authentication for MySQL
