resource "aws_iam_role" "codebuild_role" {
  name               = "${var.app_name}-env-builkd-role"
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
    effect    = "Allow"
    actions   = local.allowed_aws_actions
    resources = ["*"]
  }


}
resource "aws_iam_role_policy" "codebuild_role_policy" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.codebuild-access.json
}
