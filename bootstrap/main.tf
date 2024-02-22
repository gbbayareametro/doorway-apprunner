module "codebuild" {
    source = "../codebuild"
    description = "Inital Doorway Application Delivery Bootstrap"
    project_use = "bootstrap-env"
    stack = "bootstrap"
    environment = "bootstrap"
    output_artifact_name = "tfstate"
    environment_variables = [
        {"TF_WORKSPACE": "doorway-bootstrap"}
    ]
  
}