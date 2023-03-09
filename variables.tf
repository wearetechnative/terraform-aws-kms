variable "name" {
  description = "Unique name for KMS key and alias."
  type        = string
}

variable "resource_policy_additions" {
  description = "Additional IAM policy statements in Terraform object notation."
  type = any
  default = null
}

variable "guarded_role_access" {
  description = <<EOT
Defaults to TRUE.
This will create a policy that will allow all access based on principal tag landing_zone_usertype with value devops_administrator.
Setting tags starting with landing_zone_ is a guarded feature in our landing zone and can only be done from the management account.
This setting extends the KMS so that these compliant roles are always able to access any KMS keys.
EOT
  type = bool
  default = true
}
