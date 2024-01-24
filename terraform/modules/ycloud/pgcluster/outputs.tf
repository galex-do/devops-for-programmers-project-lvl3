output "all" {
  value = yandex_mdb_postgresql_cluster.pgcluster
}

output "output_cluster_fqdn" {
  value = yandex_mdb_postgresql_cluster.pgcluster.host[0].fqdn
}
