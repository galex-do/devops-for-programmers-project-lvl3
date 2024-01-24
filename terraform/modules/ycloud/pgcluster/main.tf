resource "yandex_mdb_postgresql_cluster" "pgcluster" {
  name        = format("%s-pgc", var.project)
  environment = "PRESTABLE"
  network_id  = var.network_id

  config {
    version = var.db.version
    resources {
      resource_preset_id = var.db.cluster_scale
      disk_type_id       = "network-ssd"
      disk_size          = var.db.disk_size
    }
    postgresql_config = {
      max_connections = 100
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    zone      = var.zone
    subnet_id = var.subnet_id
  }
}

resource "yandex_mdb_postgresql_user" "dbuser" {
  cluster_id = yandex_mdb_postgresql_cluster.pgcluster.id
  name       = var.db_user
  password   = var.db_password
  depends_on = [yandex_mdb_postgresql_cluster.pgcluster]
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.pgcluster.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.dbuser.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  depends_on = [yandex_mdb_postgresql_cluster.pgcluster]
}
