module "networks" {
  source           = "./modules/ycloud/network"
  net_name         = "${var.project}-net"
  subnet_name      = "${var.project}-subnet"
  subnet_zone      = var.subnet_zone
  private_net_cidr = var.private_net_cidr
  route_table_id   = null
}

module "instances" {
  source     = "./modules/ycloud/instances"
  for_each   = try(var.instances, {})
  name       = each.key
  settings   = each.value
  zone       = var.subnet_zone
  subnet_id  = module.networks.output_subnet_id
  entry_user = data.sops_file.secrets.data["entry_user"]
  entry_key  = data.sops_file.secrets.data["entry_key"]
  project    = var.project
  depends_on = [module.networks]
}

module "db" {
  source      = "./modules/ycloud/pgcluster"
  network_id  = module.networks.output_network_id
  zone        = var.subnet_zone
  subnet_id   = module.networks.output_subnet_id
  project     = var.project
  db          = var.db
  db_name     = data.sops_file.secrets.data["db_name"]
  db_user     = data.sops_file.secrets.data["db_user"]
  db_password = data.sops_file.secrets.data["db_password"]
  depends_on  = [module.networks]
}

module "dns_zone" {
  source  = "./modules/ycloud/dnszone"
  dns     = var.dns-public
  project = var.project
}

# there can be time between alb apply and previous modules - alb needs ssl certificate to be valid, but let's encrypt not doing this in a moment (can spend up to 1 hour).

module "alb" {
  source       = "./modules/ycloud/alb"
  project      = var.project
  network_id   = module.networks.output_network_id
  zone         = var.subnet_zone
  subnet_id    = module.networks.output_subnet_id
  targets      = local.output_instances
  dns          = var.dns-public
  backend_port = var.app.service_port
  healthcheck  = var.app.healthcheck
  ssl_cert_id  = module.dns_zone.output_certificate_id
  depends_on   = [module.networks, module.instances, module.dns_zone]
}

module "dns_record" {
  source      = "./modules/ycloud/dnsrecord"
  dns         = var.dns-public
  zone_id     = module.dns_zone.output_zone_id
  external_ip = ["${module.alb.output_external_ip}"]
  depends_on  = [module.alb]
}

module "sshfile" {
  source               = "./modules/local/sshconfig"
  instances_data       = local.output_instances
  entry_user           = data.sops_file.secrets.data["entry_user"]
  entry_key            = data.sops_file.secrets.data["entry_key"]
  ssh_cluster_name     = var.project
  config_relative_path = "../ansible"
  depends_on           = [module.instances]
}

module "ansible_vars" {
  source = "./modules/local/vars"
  values = {
    secret_db_name          = data.sops_file.secrets.data["db_name"]
    secret_db_user          = data.sops_file.secrets.data["db_user"]
    secret_db_password      = data.sops_file.secrets.data["db_password"]
    secret_db_address       = module.db.output_cluster_fqdn
    secret_datadog_api_key  = data.sops_file.secrets.data["datadog_api_key"]
    secret_datadog_app_key  = data.sops_file.secrets.data["datadog_app_key"]
    secret_datadog_api_url  = data.sops_file.secrets.data["datadog_api_url"]
    application_public_port = var.app.service_port
    application_fqdn        = trimsuffix(var.dns-public.records[0], ".")
  }
  config_relative_path = "../ansible/group_vars/all"
}

resource "datadog_monitor" "http_check" {
  name    = "HTTP Endpoint Check"
  type    = "service check"
  message = "API is down!"
  tags    = ["service:http-check"]

  query = "\"http.can_connect\".over(\"instance:checking_local_connection_to_redmine\",\"url:http://127.0.0.1:${var.app.service_port}\").by(\"*\").last(3).count_by_status()"
}
