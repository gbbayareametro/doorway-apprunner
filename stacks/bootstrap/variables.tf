variable "pipeline_environment" {
    type = string
    default = "dev"
  
}
variable "infra_pipeline_envs" {
    type = list(string)
    default = [ "oneoff" ]
    description = "List of environments that will be created by the codepipeline this creates - defaults to only oneoff"
}


