---
title: "Azure Log Analytics"
linkTitle: "Log Analytics"
weight: 60
description: >
    Deep Dive into Azure Log Analytics workspaces and linking to an Azure Log Analytics Cluster.
---

## Azure Log Analytics

The Azure Log Analytics agent collects telemetry on Azure resources, and even on-premises machines, and those monitored by System Center Operations Manager and sends it collected data to your Log Analytics workspace in Azure Monitor.
The Log Analytics agent also supports insights and other services in Azure Monitor such as VM insights and Azure Security Center.

### Azure Log Analytics Workspaces

Log Analytics is a tool in the Azure portal to edit and run log queries from data collected by Azure Monitor Logs and interactively analyze their results.
You can use Log Analytics queries to retrieve records that match particular criteria, identify trends, analyze patterns, and provide a variety of insights into your data.

### Azure Log Analytics Cluster

Azure Monitor Logs Dedicated Clusters are a deployment option that enables advanced capabilities for Azure Monitor Logs customers. Customers can select which of their Log Analytics workspaces should be hosted on dedicated clusters.
Capabilities that require dedicated clusters currently include: Customer-managed Keys, Double encryption, Availability Zones, Lockbox and Multi-workspace.

> __NOTE:__ Dedicated clusters require customers to commit for at least 500 GB of data ingestion per day.

#### Linking Log Analytics Workspaces to a Log Analytics Cluster in your current subscription

* To link an existing Log Analytics Cluster to a `COVID 19 EU Digital Green Certificate Project`'s Log Analytics Workspaces, finstly enable `enable_log_analytics_workspace` to `true` and add the resource id of the cluster in `log_analytics_cluster_id` in `terraform.tfvars`

```terraform
...
enable_log_analytics_workspace      = true
log_analytics_cluster_id            = "<id>"
...
```

### Azure Log Analytics Solution

Monitoring solutions in Azure Monitor provide analysis of the operation of an Azure application or service.

#### Azure Log Analytics Solutions table

| Log Analytics Solution | Publisher | Product                      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ---------------------- | --------- | ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContainerInsights      | Microsoft | OMSGallery/ContainerInsights | Container insights is a feature designed to monitor the performance of container workloads.                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| KeyVaultAnalytics      | Microsoft | OMSGallery/KeyVaultAnalytics | Key Vault insights provides comprehensive monitoring of your key vaults by delivering a unified view of your Key Vault requests, performance, failures, and latency.                                                                                                                                                                                                                                                                                                                                                                            |
| SecurityInsights       | Microsoft | OMSGallery/SecurityInsights  | Microsoft Azure Sentinel is a scalable, cloud-native, security information event management (SIEM) and security orchestration automated response (SOAR) solution. Azure Sentinel delivers intelligent security analytics and threat intelligence across the enterprise, providing a single solution for alert detection, threat visibility, proactive hunting, and threat response.The Azure Sentinel PowerShell module (Az.SecurityInsights) allows you to interact with the following components: * Incidents * Analytics Rules (Alert Rules) |
| NetworkMonitoring      | Microsoft | OMSGallery/NetworkMonitoring | Network Monitoring insights is a feature designed to monitor the performance of Network Monitoring traffic.                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ServiceMap             | Microsoft | OMSGallery/ServiceMap        | Service Map automatically discovers application components on Windows and Linux systems and maps the communication between services. With Service Map, you can view your servers in the way that you think of them: as interconnected systems that deliver critical services. Service Map shows connections between servers, processes, inbound and outbound connection latency, and ports across any TCP-connected architecture, with no configuration required other than the installation of an agent.                                       |
| AzureActivity          | Microsoft | OMSGallery/AzureActivity     | The Activity log is a platform log in Azure that provides insight into subscription-level events. This includes such information as when a resource is modified or when a virtual machine is started. You can view the Activity log in the Azure portal or retrieve entries with PowerShell and CLI. This article provides details on viewing the Activity log and sending it to different destinations.                                                                                                                                        |
| Updates                | Microsoft | OMSGallery/Updates           | Enable Update Management using Azure Resource Manager template                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ChangeTracking         | Microsoft | OMSGallery/ChangeTracking    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| AntiMalware            | Microsoft | OMSGallery/AntiMalware       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| SecurityInsights       | Microsoft | OMSGallery/SecurityInsights  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| SQLAssessmentPlus      | Microsoft | OMSGallery/SQLAssessmentPlus |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |


### Azure Log Analytics Diagnostic Setting

Manages a Diagnostic Setting for an existing Resource

#### Azure Log Analytics Diagnostic Setting table

| Resource               | Log                               | Metric                       |
| ---------------------- | --------------------------------- | ---------------------------- |
| KeyVault               | AuditEvent                        | AllMetrics                   |
| ACR                    | ContainerRegistryRepositoryEvents | ContainerRegistryLoginEvents |
| MySQL Server           | MySqlAuditLogs, MySqlSlowLogs     | AllMetrics                   |
| AKS                    | oms_agent                         | oms_agent                    |
