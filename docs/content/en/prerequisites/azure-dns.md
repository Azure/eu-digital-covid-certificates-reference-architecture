---
title: "Azure DNS - Setting Up a Custom DNS within Azure DNS"
linkTitle: "Azure DNS"
weight: 20
description: >
    This guide shows the following steps to create a Custom DNS in Azure DNS aswell as adding the correct Varables for the Configuration to be utilized by The Reference Architecture.
---


## Prerequisites

You must have a domain name available to test with that you can host in Azure DNS.
You must have full control of this domain. Full control includes the ability to set the name server (NS) records for the domain.

## Create a DNS zone

1. Go to the [Azure portal](https://portal.azure.com/) to create a DNS zone. Search for and select **DNS zones**.
1. Select Create **DNS zone**.
1. On the Create DNS zone page, enter the following values, and then select Create. For example:

    | Setting        | Example Value   | Details                                                                                                                                                                                                                                                                            |
    | -------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | Resource group | `edgc-dns-rg`    | Create a resource group. The resource group name must be unique within the subscription that you selected. The location of the resource group has no impact on the DNS zone. Note to reference this resource group as `parent_dns_zone_rg_name` in `terraform.tfvars` config file. |
    | Zone child     | leave unchecked | Since this zone is not a [child zone](https://docs.microsoft.com/en-us/azure/dns/tutorial-public-dns-zones-child) you should leave this unchecked                                                                                                                                  |
    | Name           | `contoso.com`    | Field for your parent zone name. Note to DNS as `parent_dns_zone_name` in `terraform.tfvars` config file.                                                                                                                                                                          |
    | Location       | North Europe    | This field is based on the location selected as part of Resource group creation                                                                                                                                                                                                    |

## Retrieve name servers

Before you can delegate your DNS zone to Azure DNS, you need to know the name servers for your zone.

1. With the DNS zone created, in the Azure portal Favorites pane, select All resources. On the All resources page, select your DNS zone.
2. Retrieve the name servers from the DNS zone page. the assigned ns will look similar to: `ns1-01.azure-dns.com`, `ns2-01.azure-dns.net`, `ns3-01.azure-dns.org`, and `ns4-01.azure-dns.info`.

## Delegate the domain

Once the DNS zone gets created and you have the name servers,
you'll need to update the parent domain with the Azure DNS name servers.
Each registrar has its own DNS management tools to change the name server records for a domain.

1. In the registrar's DNS management page, edit the NS records and replace the NS records with the Azure DNS name servers.
1. When you delegate a domain to Azure DNS, you must use the name servers that Azure DNS provides. Use all four name servers, regardless of the name of your domain. Domain delegation doesn't require a name server to use the same top-level domain as your domain.
1. Once All Azure NS have been set and podagated, you can verify the DNS by testing with the follwoing command to verify the NS records.

### For Windows verify DNS in command pronmpt

```cmd
nslookup -type=SOA contoso.com

```

### For linux/Mac verify DNS in command pronmpt

```bash
dig contoso.com

```

## Applying DNS values to terraform.tfvars

Here are the relavent DNS varables required for `terraform.tfvars` file.

```terraform
..
parent_dns_zone_name                = "contoso.com"
parent_dns_zone_rg_name             = "edgc-dns-rg"
..
```


Read about the [Visual Studio Code Dev Container]({{< relref "devcontainer.md" >}}) in the next section.
