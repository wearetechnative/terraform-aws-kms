variable "name" {
  description = "Unique name for KMS key and alias."
  type        = string
}

variable "resource_policy_additions" {
  description = "Additional IAM policy statements in Terraform object notation."
  type = any
  default = null
}
