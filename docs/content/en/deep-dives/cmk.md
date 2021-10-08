---
title: "Customer Managed Keys"
linkTitle: "CMK"
weight: 30
description: >
    Deep Dive into Customer Managed Keys
---

## Customer Managed Keys

Service Encryption provides a layer of encryption for customer data-at-rest giving customers two options for encryption key management: Microsoft-managed keys or Customer-managed Key. When using Microsoft-managed keys, Microsoft online services automatically generate and securely store the root keys used for Service Encryption.

Customers with requirements to control their own root encryption keys can use Service Encryption with Customer-managed Key. Using Customer-managed Key, customers can generate their own cryptographic keys using either an on-premises Hardware Service Module (HSM) or Azure Key Vault (AKV). Customer root keys are stored in AKV, where they can be used as the root of one of the keychains that encrypts customer mailbox data or files. Customer root keys can only be accessed indirectly by Microsoft online service code for data encryption and cannot be accessed directly by Microsoft employees.

### Table of Service which Use Customer-Managed Keys

| Service      | Key Name             | Key role assimgment scope             | Key Type | Key Size | Key Options        |
| ------------ | -------------------- | ------------------------------------- | -------- | -------- | ------------------ |
| AKS          | aks-encryption-key   | AKS User Assigned Identity            | RSA-HSM  | 2048     | unwrapKey, wrapKey |
| MySQL Server | mysql-encryption-key | MySQL Server System Assigned Identity | RSA-HSM  | 2048     | unwrapKey, wrapKey |
