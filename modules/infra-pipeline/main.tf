

module "tf_state_bucket" {
  source = "../../modules/s3"
  name   = "${var.name}-artifacts"
}

module "log_bucket" {
  source = "../../modules/s3"
  name   = "${var.name}-logs"
}

data "aws_codestarconnections_connection" "github" {
  name = "doorway-github-connection"
}
# trunk-ignore(checkov/CKV_TF_1): global terraform registry doesn't use commit hash versioning
module "kms" {
  for_each    = toset(var.build_envs)
  source      = "terraform-aws-modules/kms/aws"
  version     = "2.2.0"
  description = "Encryption Key for${var.app_name}-${each.value} database parameters"
}
module "network_build" {
  for_each      = toset(var.build_envs)
  source        = "../network_build"
  name          = "${var.app_name}-${each.key}-network"
  pipeline_name = var.name
  app_name      = var.app_name
  log_bucket    = module.log_bucket.bucket
  environment   = each.key
}
module "db_build" {
  for_each      = toset(var.build_envs)
  source        = "../../modules/db_build"
  log_bucket    = module.log_bucket.bucket
  name          = "${var.app_name}-${each.key}-db-build"
  pipeline_name = var.name
  app_name      = var.app_name
  environment   = each.key
}
# module "db_migrator" {
#   for_each                    = toset(var.build_envs)
#   source                      = "../db_migrator"
#   stack_prefix                = "${var.app_name}-${each.value}"
#   log_bucket                  = module.log_bucket.bucket
#   log_bucket_arn              = module.log_bucket.arn
#   artifact_encryption_key_arn = module.tf_state_bucket.encryption_key_arn
#   db_server_id                = "${var.app_name}-${each.value}"

# }
resource "aws_codepipeline" "infra-pipeline" {
  role_arn = aws_iam_role.codepipeline_role.arn
  name     = var.name
  artifact_store {
    location = module.tf_state_bucket.bucket
    type     = "S3"
    encryption_key {
      id   = module.tf_state_bucket.encryption_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "InfraSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["infra-source"]
      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.infra_source_repo
        BranchName       = var.infra_source_branch
      }

    }
  }
  dynamic "stage" {
    for_each = var.build_envs
    content {
      name = stage.value
      action {
        name            = "Network"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["infra-source"]
        version         = "1"
        run_order       = 1
        configuration = {
          ProjectName = module.network_build[var.build_envs[stage.key]].name
        }
      }
      action {
        name            = "Database"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["infra-source"]
        version         = "1"
        run_order       = 2
        configuration = {
          ProjectName = module.db_build[var.build_envs[stage.key]].name
        }
      }
      # # action {
      #   name            = "DatabaseMigration"
      #   category        = "Build"
      #   owner           = "AWS"
      #   provider        = "CodeBuild"
      #   input_artifacts = ["infra-source"]
      #   version         = "1"
      #   run_order       = 2
      #   configuration = {
      #     ProjectName = module.db_migrator[var.build_envs[stage.key]].name
      #   }
      # }
    }

  }
}
