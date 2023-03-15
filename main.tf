resource "aws_kms_key" "this" {
  description = var.name
  key_usage   = "ENCRYPT_DECRYPT"

  enable_key_rotation = true

  policy = data.aws_iam_policy_document.kms_policy.json

lifecycle {
    prevent_destroy = true
  }  
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

# dirty workaround because aws_kms_key will hang on policy propagation
data "aws_iam_role" "kms_access_role" {
  for_each = { for v in var.role_access : v => v }

  name = each.key
}

data "aws_iam_policy_document" "kms_policy" {
  source_policy_documents   = concat([data.aws_iam_policy_document.kms_standard_policy.json]
    , var.resource_policy_additions != null ? [ jsonencode(var.resource_policy_additions) ] : []
    , data.aws_iam_policy_document.guarded_roles[*].json
    , data.aws_iam_policy_document.access_role[*].json
  )
}

data "aws_iam_policy_document" "guarded_roles" {
  count = var.guarded_role_access ? 1 : 0
  
  statement {
    sid = "Allow guarded roles to access the KMS at any time."

    actions = [
      "kms:*",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.id]
    }

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/landing_zone_usertype"
      values   = ["devops_administrator"]
    }
  }
}

data "aws_iam_policy_document" "access_role" {
  count = length(data.aws_iam_role.kms_access_role) > 0 ? 1 : 0

  statement {
    sid = "Allow IaC tooling to handle KMS key and to create grants for new resources."

    actions = [
      "kms:*",
    ]

    principals {
      type        = "AWS"
      # using our Terraform role was a bad idea :(
      identifiers = [ for k, v in data.aws_iam_role.kms_access_role : v.arn ]
    }

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms_standard_policy" {
  # revisit replacing this with a KMS grant as KMS grants can work for AWS backup principals
  # TerraForm AWS provider bug: https://github.com/hashicorp/terraform-provider-aws/issues/13994
  statement {
    sid = "Allow logwatch to use KMS key for encryption"

    actions = ["kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
    "kms:Describe*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:log-group:*"]
    }
  }

  statement {
    sid = "Allow SES to use KMS key for encryption"

    actions = ["kms:GenerateDataKey*", "kms:Decrypt*" ]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    resources = ["*"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:configuration-set/*"]
    }
  }

  statement {
    sid = "Allow CloudTrail and AWS Config to encrypt/decrypt logs"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "kms:GenerateDataKey"
      , "kms:Decrypt"
    ]

    resources = ["*"]
  }

  statement {
    sid = "Allow Cloudtrail to use KMS key for encryption"

    actions = ["kms:GenerateDataKey", "kms:Decrypt" ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    resources = ["*"]

    # # disabled to support CloudTrail for organizations
    # condition {
    #   test     = "StringLike"
    #   variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    #   values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:trail/*"]
    # }
  }

  statement {
    sid = "Allow CloudFront logging to an S3 bucket with bucket keys."

    actions = ["kms:GenerateDataKey", "kms:Decrypt"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    resources = ["*"]
  }

  statement {
    sid = "Allow Cloudtrail Logs to use KMS key for VPC flow logs"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.id]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:*"]
    }
  }

  statement {
    sid = "Allow EventBridge service to use KMS key."

    actions = [
      "kms:Decrypt*",
      "kms:GenerateDataKey*"
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["*"]
  }
}
