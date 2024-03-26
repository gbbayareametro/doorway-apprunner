resource "aws_iam_role" "apprunner_role" {
  name               = "${var.app_name}-${var.environment}-apprunner-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["tasks.apprunner.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "apprunner-access" {

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:*", "ssm:*"]
    resources = ["*"]
  }


}
resource "aws_iam_role_policy" "codebuild_role_policy" {
  role   = aws_iam_role.apprunner_role.name
  policy = data.aws_iam_policy_document.apprunner-access.json
}
