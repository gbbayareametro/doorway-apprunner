resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild_role_${local.workspace}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "codebuild-access" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:*",
      "codepipeline:*",
      "codebuild:*"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = local.allowed_aws_actions
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateNetworkInterfacePermission"]
    resources = ["arn:aws:ec2:us-east-1:123456789012:network-interface/*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["kms:Encrypt", "kms:Decrypt"]
    resources = [
      module.tf_state_bucket.encryption_key_arn,
      module.log_bucket.encryption_key_arn


    ]
  }
}
resource "aws_iam_role_policy" "codebuild_role_policy" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.codebuild-access.json
}
