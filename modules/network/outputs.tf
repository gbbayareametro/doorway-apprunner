output "vpc_id" {
    value = module.vpc.vpc_id
  
}
output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}
output "database_subnets_cidr_blocks" {
    value = module.vpc.database_subnets_cidr_blocks
  
}