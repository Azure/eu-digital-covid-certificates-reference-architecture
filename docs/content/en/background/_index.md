---
title: "Background"
linkTitle: "Background"
weight: 10
---
## Project purpose
The Azure platform offers some of the most extensive and advanced controls for protecting security and privacy of customer data.

The reference architecture in this repository is intended to showcase some of these controls making Azure a great choice for hosting mission critical workloads. As context for this exercise, rather than developing a fictitious workload, we will adopt a familiar (at least in the European Union), mission critical, distributed, and open-source workload. This choice will allow us to focus on the cloud deployment and configuration best practices, leveraging existing code for the workload itself.

## Introducing the "EU Digital Green Ceritificates" project
The "EU Digital Green Ceritificates" project (aka "EU Digital Covid Certificates" project, hereforth EU DCC), is intended to facilitate free movement of EU citizens in compliance to a common set of COVID regulations and allowing for some level of per-country customization. It was Developed by Deutsche Telekom and SAP and shared as open source for implementation and hosting by all EU member countries. The repository for the project can be found [here](https://github.com/eu-digital-green-certificates/dgc-overview).

### High level architecture
The project includes three main sets of components:
- **EU Digital COVID Cert Gateway**. This is a centrally hosted component designed to faciliate the management and distribution of public keys from each member country to all others.
- **Reference workloads for member countries**. A set of components offered as sample implementations for various services like certificate issuing, verification services, and business rule services. These are intended for deployment by each EU member country.
- **Reference mobile apps**. Lastly, in order to help implement mobile applications for storing COVID certificates (for citizens) and verifying compliance status (for businesses, public venues, and border patrol), sample applications for Android and iOS platforms are included.

### Credits
Many thanks to all contributors to the [EU Digital Green Certificates](https://github.com/orgs/eu-digital-green-certificates) projects. We leverage their work in this reference architecture and we are thankful for the opportunity they provided.

## Guiding principles for the Azure reference architecture
The EU DCC project itself does not prescribe how the reference components should be deployed or hosted leaving some key design choices to each implementation team.
The  following are some of the principles guiding our design choices for the Azure reference architecture.
- All user-identifiable information is encrypted in transit, and at rest with Customer Managed Keys (CMK)
- The infrastructure control plane follows best practices and limits access at authorisation, network and application levels
- Immutable, declaritive configuration and deployment management

In addition, to represent a sample EU country deploying their components, we have chosen to use Ireland as an example (see the eudcc-ie folder in the repo).

See the [Deep dives]({{< relref "../deep-dives" >}}) section for more information.

> __Calls to Action__
>
>Read about the project [prerequisites]({{< relref "../prerequisites" >}}).
