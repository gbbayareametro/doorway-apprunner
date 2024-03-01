output "secret" {
  value = module.aurora_postgresql_v2.cluster_master_user_secret
}
output "endpoint" {
  value = module.aurora_postgresql_v2.cluster_endpoint

}
