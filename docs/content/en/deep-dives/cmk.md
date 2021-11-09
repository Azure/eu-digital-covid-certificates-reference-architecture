---
title: "Customer Managed Keys"
linkTitle: "CMK"
weight: 30
description: >
    Deep Dive into Customer Managed Keys
---

## Customer Managed Keys

Service Encryption provides a layer of encryption for customer data-at-rest giving customers two options for encryption key management: Microsoft-managed keys or Customer-managed Key. When using Microsoft-managed keys, Microsoft online services automatically generate and securely store the root keys used for Service Encryption.

Customers with requirements to control their own root encryption keys can use Service Encryption with Customer-managed Key. Using Customer-managed Key, customers can generate their own cryptographic keys using either an on-premises Hardware Service Module (HSM) or Azure Key Vault (AKV). Customer root keys are stored in AKV, where they can be used as the root of one of the keychains that encrypts customer files. Customer root keys can only be accessed indirectly by Microsoft online service code for data encryption and cannot be accessed directly by Microsoft employees.

We use CMK to ensure that the cloud provider does not have access to the medical information of the citizens how have Digital COVID Certs issued by this system.

We have the Key Vault service generate the 2 keys used (details below) in a HSM backed key slot, ensuring the key is generated in a HSM and it cannot be exported from the HSM by the customer, or the cloud provider, and we grant limited access to the keys for the services that need access to use them. This means that the AKS service has access to the AKS key, but not the MySQL key, and visa versa. We also restrict the operations on this key to the bare minimum - so this key will only be able to wrap and unwrap other keys.

### MySQL

The MySQL server has its data encrypted by a Data Encryption Key (DEK), which itself is encrypted by a Key Encryption Key, which is stored in Key Vault, and has access controls applied to it.
These controls mean that if the MySQL server Managed Identity has its access revoked, it can no longer access the DEK, which means it cannot access the encrypted data.

There is more documentation for this here - [Azure Documentation](https://docs.microsoft.com/en-us/azure/mysql/concepts-data-encryption-mysql)

### AKS

For AKS we have enabled encryption of Kubernetes Persistent Volumes (using the Azure Disks Storage Class), and the OS Disks, using a CMK.

This ensures any data stored in Kubernetes is encrypted at rest, using a DEK that has been wrapped by a KEK, that is stored in the Key Vault.
Revoking the AKS clusters managed identity's access to the key will mean that AKS can no longer decrypt the key, and as such cannot decrypt the data.

There is more documentation for this here - [Azure Documentation](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)
### Key Vault Options

For this example we chose a Key Vault Premium instance and used HSM backed keys for the KEK, that are generated on the HSM.
This gives a good level of protection from the KEK being leaked (as it never leaves the HSM), but may not fufil specific FIPS level requirements, or other regulations.
For these cases, a [Managed HSM](https://docs.microsoft.com/en-us/azure/key-vault/managed-hsm/overview) may be required.

This can support importing KEKs from an [onsite HSM](https://docs.microsoft.com/en-us/azure/key-vault/managed-hsm/hsm-protected-keys-byok) that ensures the import
never leaves a HSM boundary, while allowing customers to have secure external backups of the key.

As Managed HSMs use a similar API to Key Vault, any changes needed to  use a Managed HSM would be minimal.

For lower security requirements, software backed encryption keys can also be used for CMK, for reduced cost, and easier, but less secure backup.

### Table of Service which Use Customer-Managed Keys

| Service      | Key Name             | Key role assignment scope             | Key Type | Key Size | Key Options        |
| ------------ | -------------------- | ------------------------------------- | -------- | -------- | ------------------ |
| AKS          | aks-encryption-key   | AKS User Assigned Identity            | RSA-HSM  | 2048     | unwrapKey, wrapKey |
| MySQL Server | mysql-encryption-key | MySQL Server System Assigned Identity | RSA-HSM  | 2048     | unwrapKey, wrapKey |


Read about [AAD configuration]({{< relref "aad.md" >}}) in the next section.
