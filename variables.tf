variable "name" {
  description = "Unique name for KMS key and alias."
  type        = string
}

variable "resource_policy_additions" {
  description = "Additional IAM policy statements in Terraform object notation."
  type = any
  default = null
}

variable "guarded_role_paths" {
  description = <<EOT
List of guarded roles that always have access to this KMS key along with its Terraform creator role.
Role must be defined in full like role/landing_zone/landing_zone_devops_administrator (it must always start with role/).
A star if suffixed to prevent losing the access in case the role is deleted (e.g. dangling AWS ID).
Guarded roles means they are protected from modification through SCPs. These roles are part of our landingzone setup.
EOT
  type = list(string)
  default = ["role/landing_zone/landing_zone_devops_administrator"]
}
