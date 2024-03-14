module "prod_pipeline" {
  source     = "../../modules/infra-pipeline"
  name       = "doorway-prod-pipeline"
  build_envs = ["dev"]
}
