module "kms" {
  source = "github.com/wearetechnative/terraform-aws-kms.git"

  name        = "default"
  role_access = []
  resource_policy_additions = jsondecode(data.aws_iam_policy_document.kms_iam_user_permissions.json)
}

data "aws_iam_policy_document" "kms_iam_user_permissions" {
  statement {
    sid = "Allow iam user to access the KMS at any time."

    actions = [
      "kms:*",
    ]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::999999999999:root",
        "arn:aws:iam::999999999999:user/sarah"
      ]
    }
    resources = ["*"]
  }
}
