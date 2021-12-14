# Definitions for Azure Policies to be applied
resource "azurerm_policy_set_definition" "policy_set_definition" {
  count        = var.enable_azure_policy ? 1 : 0
  name         = "${var.prefix}${var.name} Policy Definitions"
  policy_type  = "Custom"
  display_name = "${var.prefix}${var.name} Policies"

  # Deploy the built-in "Allowed locations for resource groups" Policy
  #
  # This policy enables you to restrict the locations your organization can create resource groups in. Use to enforce your geo-compliance requirements.
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": ["${azurerm_resource_group.rg.location}"]}
    }
    VALUE
  }
  # Deploy the built-in "Allowed locations" Policy
  #
  # This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region.
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": ["${azurerm_resource_group.rg.location}"]}
    }
    VALUE
  }
  # Deploy the built-in "MySQL servers should use customer-managed keys to encrypt data at rest" Policy
  #
  # Use customer-managed keys to manage the encryption at rest of your MySQL servers. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data
  # to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management.
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83cef61d-dbd1-4b20-a4fc-5fbc7da10833"
    parameter_values     = <<VALUE
    {
      "effect": { "value" : "AuditIfNotExists" }
    }
    VALUE
  }
  # Deploy the built-in "Managed disks should use a specific set of disk encryption sets for the customer-managed key encryption" Policy
  #
  # Requiring a specific set of disk encryption sets to be used with managed disks give you control over the keys used for encryption at rest. You are able to select the allowed encrypted sets and all others are rejected when attached to a disk. Learn more at https://aka.ms/disks-cmk.
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d461a302-a187-421a-89ac-84acdb4edc04"
    parameter_values     = <<VALUE
    {
      "effect": { "value" : "Audit" },
      "allowedEncryptionSets": {"value": ["${azurerm_disk_encryption_set.aks_encryption_set.id}"]}
    }
    VALUE
  }
  # Deploy the built-in "Keys using RSA cryptography should have a specified minimum key size" Policy
  #
  # Set the minimum allowed key size for use with your key vaults. Use of RSA keys with small key sizes is not a secure practice and doesn't meet many industry certification requirements.
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/82067dbb-e53b-4e06-b631-546d197452d9"
    parameter_values     = <<VALUE
    {
      "effect": { "value" : "Audit" },
      "minimumRSAKeySize": {"value": 2048}
    }
    VALUE
  }
}

# Assign Policy Definition for Azure Policies to be applied
resource "azurerm_resource_group_policy_assignment" "resource_group_policy_assignment" {
  count                = var.enable_azure_policy ? 1 : 0
  name                 = "${var.prefix}${var.name} Resource Group Policy Assignment"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_set_definition.policy_set_definition.id
  display_name         = "${var.prefix}${var.name} Policy Initiative"
  description          = "Initiative of Policies to enforce the locality, security and privacy of all the resources of ${azurerm_resource_group.rg.name}."
}
