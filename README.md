# COVID 19 EU Digital Green Certificate Project

## Project Docs site

There is a full deployment guide please look at our docs site - https://symmetrical-eureka-325a8bfe.pages.github.io/

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
## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
