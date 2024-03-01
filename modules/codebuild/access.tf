resource "aws_iam_role" "codebuild_role" {
  name               = "${var.stack_prefix}-codebuild"
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
    effect    = "Allow"
    actions   = var.allowed_aws_actions
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
    effect = "Allow"
    actions = ["s3:CreateBucket",
      "s3:GetObject",
      "s3:List*",
    "s3:PutObject"]
    resources = [
      var.log_bucket_arn,
      "${var.log_bucket_arn}/*",
    ]
  }
}
resource "aws_iam_role_policy" "codebuild_role_policy" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.codebuild-access.json
}
