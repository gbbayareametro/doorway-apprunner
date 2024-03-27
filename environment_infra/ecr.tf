



################################################################################
# Cluster
################################################################################
#trunk-ignore(checkov/CKV_TF_1): main registry doesn't version by hash
module "ecs_cluster" {
  source       = "terraform-aws-modules/ecs/aws"
  version      = "5.10.0"
  cluster_name = local.ecs_cluster_name


}
