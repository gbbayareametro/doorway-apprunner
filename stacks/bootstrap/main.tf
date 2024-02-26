module "global" {
    source = "../global"
}
module "codebuild" {
    source = "../../modules/codebuild"
    description = "Inital Doorway Application Delivery Bootstrap"
    stack_prefix = "${module.global.environment_prefix}-bootstrap"
    resource_use = "bootstrap"
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
      "ec2:DescribeAvailabilityZones",
      "rds:*",
      "kms:*",
      "iam:*"

    ]
  
}