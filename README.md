# Terraform AWS [KMS] ![](https://img.shields.io/github/workflow/status/wearetechnative/terraform-aws-kms/tflint.yaml?branch=main&style=plastic)

This module implements an KMS key usable for most scenarios.

Use
[aws_kms_grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant)
to allow least privilege to this key.

This key contains a lot of open policies by default. This is due to a
limitation in Terraform `aws_kms_grant`. See
[this](https://github.com/hashicorp/terraform-provider-aws/issues/13994) issue
as to why.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

Generally you online define the `var.name` and only use
`var.resource_policy_additions` when you use a service or resource that is not
able to access the key using grants. It's generally not recommended to use
`var.resource_policy_additions`. For general AWS services we include these
services by default into this module until
[this](https://github.com/hashicorp/terraform-provider-aws/issues/13994) can be
solved using `aws_kms_grant` as well. Please UPVOTE this issue.

## Examples

Check the example how to implement KMS.

- with_extra_iam_user_additions, if you want to give users explicit access

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
| [aws_iam_policy_document.access_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.guarded_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_standard_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.kms_access_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_guarded_role_access"></a> [guarded\_role\_access](#input\_guarded\_role\_access) | Defaults to TRUE.<br>This will create a policy that will allow all access based on principal tag landing\_zone\_usertype with value devops\_administrator.<br>Setting tags starting with landing\_zone\_ is a guarded feature in our landing zone and can only be done from the management account.<br>This setting extends the KMS so that these compliant roles are always able to access any KMS keys. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Unique name for KMS key and alias. | `string` | n/a | yes |
| <a name="input_resource_policy_additions"></a> [resource\_policy\_additions](#input\_resource\_policy\_additions) | Additional IAM policy statements in Terraform object notation. | `any` | `null` | no |
| <a name="input_role_access"></a> [role\_access](#input\_role\_access) | Access for regular roles. Explicitly defined to set compatibility with the move to var.guarded\_role\_access. Set the role name. | `list(string)` | <pre>[<br>  "OrganizationAccountAccessRole"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
<!-- END_TF_DOCS -->
