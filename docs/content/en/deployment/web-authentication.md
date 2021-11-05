---
title: "Issuance Web Authentication Setup"
linkTitle: "Issuance Web Authentication"
weight: 60
description: >
    Issuance Web Authentication Setup
---

## Issuance Web Authentication

By default, when we deploy the issuance web application, the application is
setup to allow all members of the AAD tenant to log into and issue certs.

This is due to the need for an admin to grant consent to applications that have
been directly assigned to users without their direct consent recorded in the
AAD portal.

### Restricting Access to Specific users

- Navigate to the [Active directory blade](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview) in the Azure portal.
- Search for the application name (The URL for issuance web that is printed at the end of the `make terraform` command, minus the "https://")
  e.g. "dgca-issuance-web.eudcc-ie.example.com"
- Click on the "enterprise application" result
- Click on properties
- Switch "User assignment required?" to "Yes"
- Click on "Users and Groups"
- Click "Add User/Group"
- Search for either the user you want to grant access, or the group that contains the users you want to add
- Leave role as "Default Access"
- Click "Assign"
- Click "Permissions"
- Click "Grant admin consent for _ORG_"
