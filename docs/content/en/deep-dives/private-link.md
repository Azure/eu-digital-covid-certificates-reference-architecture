---
title: "Private Link"
linkTitle: "Private Link"
weight: 10
description: >
    Deep Dive into Private Link
---

## Private Link

Azure Private Link enables you to access Azure PaaS Services and Azure-hosted customer-owned/partner services over a Private Endpoint in your virtual network.
Traffic between your virtual network and the service traverses over the Microsoft backbone network, eliminating exposure from the public Internet.
You can also create your own Private Link Service in your virtual network and deliver it privately to your customers.

This reference architecture utilizes Private Link's security & privacy benefiting from eliminating exposure from the public Internet and
opting into the whole infrastructure being inaccessible from the Internet, apart from a jump-box and ingress functionality.


## Private Link Resources

The following table lists all Resources in both EU and IE regions Private Link Networks.

| Name              | DNS Zone                                  |
| ----------------- | ----------------------------------------- |
| ACR               | privatelink.azurecr.io                    |
| AKS               | privatelink.`<region location>`.azmk8s.io |
| Key Vault         | privatelink.vaultcore.azure.net           |
| MySQL Server      | privatelink.mysql.database.azure.com      |
| PostgreSQL Server | privatelink.postgres.database.azure.com   |



Read about [Key Vault]({{< relref "key-vault.md" >}}) in the next section.
