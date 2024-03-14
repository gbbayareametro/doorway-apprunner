module "prod_pipeline" {
  source     = "../../modules/infra-pipeline"
  name       = "dw-prod-infra"
  build_envs = ["dev"]
}
