data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = [
      module.artifact_bucket.arn,
      "${module.artifact_bucket.arn}/*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:*"]
    resources = [data.aws_codestarconnections_connection.github.arn]
  }
  dynamic "statement" {
    for_each = var.build_envs
    content {
      effect = "Allow"
      actions = [
        "codebuild:*",
      ]
      resources = [
        module.network_build[var.build_envs[statement.key]].build_arn
        # module.db_build[var.build_envs[statement.key]].build_arn,
        # module.db_migrator[var.build_envs[statement.key]].build_arn
      ]
    }
  }
  dynamic "statement" {
    for_each = var.build_envs
    content {
      effect = "Allow"
      actions = [
        "codebuild:StartBuild",
      ]
      resources = [
        module.network_build[var.build_envs[statement.key]].build_arn
        # module.db_build[var.build_envs[statement.key]].build_arn,
        # module.db_migrator[var.build_envs[statement.key]].build_arn
      ]
    }

  }
  statement {
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    resources = [module.log_bucket.encryption_key_arn, module.artifact_bucket.encryption_key_arn]
  }
}
resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
