locals {
  output_instances = {
    for node in keys(var.instances) :
    node => module.instances[node].all
  }
}

output "alb" {
  value = module.alb.output_external_ip
}
