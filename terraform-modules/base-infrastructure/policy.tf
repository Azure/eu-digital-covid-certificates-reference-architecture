# Pollicy Definition for Allowed Locations
resource "azurerm_policy_set_definition" "definition_policy_allowed_location" {
  name         = "${var.prefix}${var.name} Region Policy definition"
  policy_type  = "Custom"
  display_name = "${var.prefix}${var.name} Region Policy"

  parameters = <<PARAMETERS
    {
        "allowedLocations": {
            "type": "Array",
            "metadata": {
                "description": "The list of allowed locations for resources.",
                "displayName": "Allowed locations",
                "strongType": "location"
            }
        }
    }
PARAMETERS
  # Deploy the built-in "Allowed locations for resource groups" Policy
  #
  # This policy enables you to restrict the locations your organization can create resource groups in. Use to enforce your geo-compliance requirements.
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
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
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }
}

# Assign Pollicy Definition for Allowed Locations
resource "azurerm_resource_group_policy_assignment" "assignment_policy_allowed_location" {
  name                 = "${var.prefix}${var.name} Region Group Policy assignment"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_set_definition.definition_policy_allowed_location.id
  display_name         = "${var.prefix}${var.name} Region Policy"
  description          = "This Policy enforces that only the creation of Resources in the allowed Azure regions for the scope of the resource group ${azurerm_resource_group.rg.name}."
  parameters           = <<PARAMETERS
{
  "allowedLocations": {
    "value": [ "${azurerm_resource_group.rg.location}" ]
  }
}
PARAMETERS
}
