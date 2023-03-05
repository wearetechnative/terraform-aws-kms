# Terraform AWS [KMS]

This module implements an KMS key usable for most scenarios.

Use [aws_kms_grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) to allow least privilege to this key.

This key contains a lot of open policies by default. This is due to a limitation in Terraform `aws_kms_grant`. See [this](https://github.com/hashicorp/terraform-provider-aws/issues/13994) issue as to why.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

Generally you online define the `var.name` and only use `var.resource_policy_additions` when you use a service or resource that is not able to access the key using grants. It's generally not recommended to use `var.resource_policy_additions`. For general AWS services we include these services by default into this module until [this](https://github.com/hashicorp/terraform-provider-aws/issues/13994) can be solved using `aws_kms_grant` as well. Please UPVOTE this issue.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms-standard-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.kms-access-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Unique name for KMS key and alias. | `string` | n/a | yes |
| <a name="input_resource_policy_additions"></a> [resource\_policy\_additions](#input\_resource\_policy\_additions) | Additional IAM policy statements in Terraform object notation. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
<!-- END_TF_DOCS -->
