---
title: "Certificate Generation"
linkTitle: "Certificate Generation"
weight: 30
description: >
    Generate Required Certificates
---

### Background and Further Reading

The EU Digital Covid Certificate project uses and generates many different certificates and certificate authorities (CAs). A summary of the most important certificates and CAs has been included in the table below. For a full list of these, please refer to the [upstream documentation](https://github.com/eu-digital-green-certificates/dgc-overview/blob/main/guides/certificate-governance.md) for complete documentation of these certificates and CAs.

| Owner      | Name        | Signed By CA | Description                                                                                   |
| ---------- | ----------- | ------------ | --------------------------------------------------------------------------------------------- |
| EU         | Trustanchor | Self-Signed  | Root Certificate Authority (CA)                                                               |
| Country    | Auth        | Trustanchor  | The Auth cert is used to authenthicate against the EU Gateway for read operations             |
| Country    | Upload      | Trustanchor  | The Upload cert is used to authenthicate against the EU Gateway for upload (write) operations |
| Country    | CSCA        | Trustanchor  | The Country Signing Certificate Authority (CSCA) is used to sign Document Signer Certificates        |
| Country    | DSC         | Country CSCA | The Document Signer Certificates (DSC) are used to sign individual Digital Covid Certificates       |
| Individual | DCC         | Country DSC  | The Digital Covid Certificate (DCC) that is issused to members of the general public                |

### Generating the required certificates for the Reference Architecture

Use the following command from the root folder of the Git clone to automatically generate the necessary certs for use in a test environment. For a production deployment, please refer to the [upstream dgc-participating-countries project](https://github.com/eu-digital-green-certificates/dgc-participating-countries/) for guidance on generating certificates, safe handling of certificates, and onboarding those certificates to the EU gateway.

```bash
$ make certs

[ .. SNIP .. ]

Signing IE Auth Cert
Signing IE CSCA Cert
Signing IE Upload Cert
DONE
```

> __Calls to Action__
>
>Read about [deployment]({{< relref "deployment.md" >}}) in the next section.
