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
  name               = "${local.stack_prefix}-pipeline-role"
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
  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:*",
    ]
    resources = [module.dev_db_build.build_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "codebuild:*",
    ]
    resources = [module.dev_db_build.build_arn]
  }
  statement {
    effect = "Allow"

    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
