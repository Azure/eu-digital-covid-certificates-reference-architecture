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
  e.g. "dgca-issuance-web.eudcc-ie.contoso.com"
  ![web auth search enterprise apps](/screenshots/web-auth-search-enterprise-apps.png 'Search results for enterprise Apps with the name "dgca-issuance-web.eudcc-ie.prefix.contoso.com" showing one result in the Active directory blade.')
- Click on the "enterprise application" result
- Click on properties
- Switch "User assignment required?" to "Yes"
  ![web auth enterprise app propperties](/screenshots/web-auth-enterprise-app-properties.png 'image demonstrating navigating to the properties panel of the enterprise application and enabling the User assignment required option and then saving.')
- Click on "Users and Groups"
- Click "Add User/Group"
- Search for either the user you want to grant access or the group that contains the users you want to add
  ![web auth add user and groups](/screenshots/web-auth-add-user-groups.png 'image demonstrating navigating the added user or group panel in the portal to selected desired users to access the Web Authentication and also apply the default role to.')
- Leave role as "Default Access"
- Click "Assign"
- Click "Permissions"
- Click "Grant admin consent for _ORG_"
  ![web auth assign default access role](/screenshots/web-auth-assigned-default-access-role.png 'image demonstrating a user that has been successfully added to the enterprise application and will be enabled to authenticate to the Issuance Web Authentication.')

