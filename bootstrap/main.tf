module "codebuild" {
    source = "../codebuild"
    description = "Inital Doorway Application Delivery Bootstrap"
    project_use = "bootstrap-env"
    stack = "bootstrap"
    environment = "bootstrap"
    output_artifact_name = "tfstate"
    environment_variables = [
        {"name": "TF_WORKSPACE", "value":"doorway-bootstrap"}
    ]
    allowed_aws_actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:DescribeAvailabilityZones"
    ]
  
}