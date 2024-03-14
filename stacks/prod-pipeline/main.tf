module "prod_pipeline" {
  source     = "../../modules/infra-pipeline"
  name       = "dw-infra"
  build_envs = ["dev"]
}
