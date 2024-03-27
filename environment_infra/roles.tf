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
  statement {
    effect  = "Allow"
    actions = ["kms:Encrypt", "kms:Decrypt"]
    resources = [
      aws_ssm_parameter.db_host.arn,
      aws_ssm_parameter.db_name.arn,
      aws_ssm_parameter.db_port.arn,
      aws_ssm_parameter.secret_id.arn,
      aws_ssm_parameter.vpc_id.arn,
      data.aws_ssm_parameter.sendgrid.arn,
      module.aurora_postgresql_v2.cluster_master_user_secret[0].secret_arn,
      module.module.aurora_postgresql_v2.master_user_secret_kms_key_id
    ]
  }


}
resource "aws_iam_role_policy" "apprunner_role_policy" {
  role   = aws_iam_role.apprunner_role.name
  policy = data.aws_iam_policy_document.apprunner-access.json
}
