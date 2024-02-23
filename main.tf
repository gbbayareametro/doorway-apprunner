
module "apprunner" {
  source = "./apprunner"
}

# module "network" {
#   source = "./network"
# }

# module "database" {
#   source = "./database"
#   vpc_id = module.network.vpc_id
#   database_subnet_group_name = module.network.database_subnet_group_name
#   database_subnets_cidr_blocks = module.network.database_subnets_cidr_blocks
  
  
# }