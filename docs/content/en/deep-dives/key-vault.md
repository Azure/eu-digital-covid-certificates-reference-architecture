---
title: "Key Vault"
linkTitle: "Key Vault"
weight: 20
description: >
    Deep Dive into Key Vault
---

## Background and Further Reading

Azure Key Vault is a cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys.

For more information on Azure Key Vault please refer to the [product documentation](https://docs.microsoft.com/en-us/azure/key-vault/).

### Azure Key Vault RBAC

This reference architecture's implementation of Azure Key Vault has enabled RBAC authorization as standard. Azure Key Vault RBAC is a new feature (~Feb 2021) which provides the ability to have separate permissions on individual keys, secrets, and certificates. This reduces the number of Key Vaults needed to maintain minimal access rights.

For more information on Azure Key Vault RBAC please refer to the [product documentation](https://docs.microsoft.com/en-gb/azure/key-vault/general/rbac-guide).

### Azure Spring PropertySource

Each of the upstream Spring based applications has been configured to use a Azure KeyVault Spring PropertySource. This allows the applications to load certain Spring properties from KeyVault, however it requires us to use a specific naming pattern for the KeyVault items. The table below shows which naming pattern is used for each key.

See the [Azure Key Vault Secrets Spring Boot starter client library for Java documentation](https://github.com/Azure/azure-sdk-for-java/tree/3f31d68eed6fbe11516ca3afe3955c8840a6e974/sdk/spring/azure-spring-boot-starter-keyvault-secrets) and [algorithm](https://github.com/Azure/azure-sdk-for-java/blob/3f31d68eed6fbe11516ca3afe3955c8840a6e974/sdk/spring/azure-spring-boot/src/main/java/com/azure/spring/keyvault/KeyVaultOperation.java#L165-L177) for more details.

### Azure Key Vault Provider for Secrets Store CSI Driver (AKS)

The Azure Key Vault provider for Secrets Store CSI driver allows us to get secret contents stored in an Azure Key Vault instance and use the Secrets Store CSI driver interface to mount them into Kubernetes Pods.

This reference architecture uses this CSI Driver to mount the various certificates into the approperiate Kubernetes Pod's filesystem. This method was chosen as it reduced the number of upstream code changes necessary, however, ideally this would be replaced with direct integration with KeyVault, discussed in the next section below.

For more information on this CSI driver please refer to the [upstream documentation](https://github.com/Azure/secrets-store-csi-driver-provider-azure).

### Future: Direct integration of KeyVault into the upstream applications

Ideally, each of the upstream applications would never require access to read the various certificate private keys from Key Vault and they would instead integrate directly with the Key Vault sigining APIs. This would significantly reduce the risk of accidentally exposing private keys in the event of a misconfigration, malware, breach or other security incident by storing the Private Keys in a non-exportable HSM backed key.

Due to the number of changes that would be necessary to the upstream codebase, we chose to not implement this as part of this reference architecture, however we would recommend this be implemented for any production workloads.

## EU Key Vault

The following table lists all items in the EU Key Vault, along with a short description of their purpose.

| Name                             | Type        | Naming Scheme         | Description                                                                                                                                                         |
| -------------------------------- | ----------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| trustanchor                      | Certificate | Freeform              | Root Certificate Authority (CA) Private Key and Certificate bundle                                                                                                  |
| dgc-trustanchor-certificatealias | Secret      | Spring PropertySource | The certificate alias to use from within the trustanchor bundle                                                                                                     |
| mysql-pw                         | Secret      | Freeform              | The Azure MySQL Administrative User Password. Unused by the Reference Architecture, however may be necessary for day to day opereations in a production environment |
| mysql-encryption-key             | Key         | Freeform              | Encryption key used for [Azure MySQL Customer Managed Key](https://docs.microsoft.com/en-us/azure/mysql/concepts-data-encryption-mysql)                            |
| aks-encryption-key               | Key         | Freeform              | Encryption key used for [Azure Kubernetes Service Customer Managed Key](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)               |

## IE Key Vault

The following table lists all items in the IE Key Vault, along with a short description of their purpose.

| Name                                         | Type        | Naming Scheme         | Description                                                                                                                                                               |
| -------------------------------------------- | ----------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| trustanchor-content                          | Secret      | Freeform              | Root Certificate Authority (CA) Private Key and Certificate bundle                                                                                                        |
| dgc-gateway-connector-trustanchor-password   | Secret      | Spring PropertySource | Password for the trustanchor bundle                                                                                                                                       |
| dgc-gateway-connector-trustanchor-alias      | Secret      | Spring PropertySource | The certificate alias to use from within the trustanchor bundle                                                                                                           |  |
| msal-authentication-client-secret            | Secret      | Freeform              | The Application Client Secret used for AAD Authentication on the Issuance Web Portal                                                                                                                                                                          |
| tls-trust-store-content                      | Secret      | Freeform              | The TLS Trust Store bundle in PKCS #12 format. This is used for [HTTP Public Key Pinning](https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning) on all HTTP connections. |
| dgc-gateway-connector-tlstruststore-password | Secret      | Spring PropertySource | Password for the TLS Trust Store bundle                                                                                                                                   |
| tls-key-store                                | Certificate | Freeform              | The TLS Key Store bundle contains the Auth certificate which is used to Authenticate a country to the EU Gateway                                                          |
| dgc-gateway-connector-tlskeystore-alias      | Secret      | Spring PropertySource | The certificate alias to use from within the TLS Key Store bundle                                                                                                                                     |
| upload-key-store                             | Certificate | Freeform              | The Upload Key Store bundle contains the Upload certificate which is used to sign uploads from a country to the EU Gateway                                                |
| dgc-gateway-connector-uploadkeystore-alias   | Secret      | Spring PropertySource | The certificate alias to use from within the Upload Key Store bundle                                                                                                                                  |
| dsc-key-store                                | Certificate | Freeform              | The DSC Key Store bindle contains the Document Signer Certificates which are used to sign end user Digital Covid Certificates                                              |
| issuance-certalias                           | Secret      | Spring PropertySource | The certificate alias to use from within the DSC Key Store bindle                                                                                                                                                                          |
| mysql-pw                                     | Secret      | Freeform              | The Azure MySQL Administrative User Password. Unused by the Reference Architecture, however may be necessary for day to day operations in a production environment       |
| mysql-encryption-key                         | Key         | Freeform              | Encryption key used for [Azure MySQL Customer Managed Key](https://docs.microsoft.com/en-us/azure/mysql/concepts-data-encryption-mysql)                                   |
| aks-encryption-key                           | Key         | Freeform              | Encryption key used for [Azure Kubernetes Service Customer Managed Key](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)                      |


Read about [Customer managed keys]({{< relref "cmk.md" >}}) in the next section.
