module "prod_pipeline" {
  source               = "../../modules/infra-pipeline"
  pipeline_environment = "prod"
  build_envs           = ["dev", "staging", "prod"]
}
