
---
title: "EU Digital COVID Certificate - Azure Example Deployment"
linkTitle: "Documentation"
type: "docs"
weight: 20

cascade:
- type: "blog"
  # set to false to include a blog section in the section nav along with docs
  toc_root: true
  _target:
    path: "/blog/**"
- type: "docs"
  _target:
    path: "/**"
---

## EU Digital Green Ceritificates

### WHY
The project is intended to facilitate free movement of EU citizens within EU countries in compliance to a common set of COVID regulations and allowing for some level of per-country customization
### WHO
Developed by Deutsche Telekom and SAP and shared as open source for implementation and hosting by all EU member countries

### WHAT
The project includes:
- EU Digital Green Cert Gateway
- Reference workloads for member countries (Certificate Issuing and Verifying services, business rule services)
- Reference mobile apps (Wallet and Verifier apps)

## Base Principles

- All End User Identifiable Information is encrypted at rest, with Customer Managed Keys
- The infrastructure control plane follows best practices and limits access at authorisation, network and application levels
- Immutable, declaritive configuration and deployment management


