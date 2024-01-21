## ---------------------------------------------------------------------------------------------------------------------
## Owner: Soumen_user@mylabs.com, Hristo_user@mylabs.com
## product_id: 12345
## Description: Virtual Private Cloud
## ---------------------------------------------------------------------------------------------------------------------

## ---------------------------------------------------------------------------------------------------------------------
## Owner: Soumen_user@mylabs.com, Hristo_user@mylabs.com
## product_id: 12345
## used_for: prod, dev
## Description: Exclude rules that are not applicable for our repositories
## ---------------------------------------------------------------------------------------------------------------------

resource "wiz_cicd_scan_policy" "mylabs_12345_all_wizcli_misconfigurations_block_vpc" {
  name        = "${local.prefix}-12345-all-wizcli-misconfigurations-block-vpc"
  description = "Wiz CLI IaC Block policy for product_id=12345, Owner: soumen_user@mylabs.com"

  policy_lifecycle_enforcements {
    deployment_lifecycle = "ADMISSION_CONTROLLER"
    enforcement_method   = "BLOCK"
  }
  policy_lifecycle_enforcements {
    deployment_lifecycle = "CLI"
    enforcement_method   = "BLOCK"
  }

  iac_params {
    iac_count_threshold = 1
    severity_threshold  = "HIGH"
    ignored_rules = concat(
      local.mylabs_all_wizcli_misconfigurations_all_ignored_rules,
      # [VPC-080] Unused Security Group should be deleted
      data.wiz_cloud_configuration_rules.vpc_080.cloud_configuration_rules[*].id,
      # [VPC-086] EC2 Security Group should restrict outbound traffic to specific ports
      data.wiz_cloud_configuration_rules.vpc_086.cloud_configuration_rules[*].id,
      # [VPC-111] 123
      data.wiz_cloud_configuration_rules.vpc_123.cloud_configuration_rules[*].id,

    )
  }
}      
