---
title: "KeyVault"
linkTitle: "KeyVault"
weight: 20
description: >
    Deep Dive into KeyVault
---

## Key Vault

Azure Key Vault is a cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys. Key Vault service supports two types of containers: vaults and managed hardware security module(HSM) pools. Vaults support storing software and HSM-backed keys, secrets, and certificates. Managed HSM pools only support HSM-backed keys

### Azure Key Vault Access Policy Permissions

This project implementation of Azure Key Vault has enabled RBAC authorization as standard, which allows the ability for the finer granularity of granting the smallest sub-section of resources the the the necessary access to read then again only the required secrets and keys.
