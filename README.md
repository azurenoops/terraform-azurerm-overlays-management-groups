<!-- markdownlint-configure-file { "MD004": { "style": "consistent" } } -->
<!-- markdownlint-disable MD033 -->
<p align="center">  
  <h1 align="left">Azure NoOps Accelerator Management Groups Module</h1>
  <p align="center">
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="MIT License"></a>
    <a href="https://registry.terraform.io/modules/azurenoops/overlays-management-groups/azurerm/"><img src="https://img.shields.io/badge/terraform-registry-blue.svg" alt="Azure NoOps TF Registry"></a></br>
  </p>
</p>
<!-- markdownlint-enable MD033 -->

This Overlay terraform module simplifies the creation of custom management groups to be used in a [SCCA compliant Mission Enclave](https://registry.terraform.io/modules/azurenoops/overlays-hubspoke/azurerm/latest).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Mission Enclave. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

### [Managment Group Module](module)

This module is used to create a Management Group in Azure. It can be used to create a new Management Group or to add a subscription to an existing Management Group. It can also be used to create a new Management Group and add a subscription to it. 

```hcl
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
```