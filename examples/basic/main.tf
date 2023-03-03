# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an Azure Management Group Hierarchy
DESCRIPTION: The following components will be options in this deployment
             * Management Group Hierarchy
AUTHOR/S: jspinella
*/

################################################
### Management Group Configuations  ###
################################################

data "azurerm_subscription" "current_client" {}

module "mod_management_group" {
  source            = "../.."
  root_id           = "anoa"
  root_parent_id    = data.azurerm_subscription.current_client.tenant_id
  root_name         = "anoa"
  management_groups =  {
    "platforms" = {
      display_name               = "platforms"
      management_group_name      = "platforms"
      parent_management_group_id = "anoa"
      subscription_ids           = []
    },
    "workloads" = {
      display_name               = "workloads"
      management_group_name      = "workloads"
      parent_management_group_id = "anoa"
      subscription_ids           = []
    },
    "sandbox" = {
      display_name               = "sandbox"
      management_group_name      = "sandbox"
      parent_management_group_id = "anoa"
      subscription_ids           = []
    },
    "identity" = {
      display_name               = "identity"
      management_group_name      = "identity"
      parent_management_group_id = "platforms"
      subscription_ids           = []
    },
    "transport" = {
      display_name               = "transport"
      management_group_name      = "transport"
      parent_management_group_id = "platforms"
      subscription_ids           = ["${data.azurerm_subscription.current_client.subscription_id}"]
    },
    "management" = {
      display_name               = "management"
      management_group_name      = "management"
      parent_management_group_id = "platforms"
      subscription_ids           = []
    },
    "internal" = {
      display_name               = "internal"
      management_group_name      = "internal"
      parent_management_group_id = "workloads"
      subscription_ids           = []
    },
    "partners" = {
      display_name               = "partners"
      management_group_name      = "partners"
      parent_management_group_id = "workloads"
      subscription_ids           = []
    }
  }
}

