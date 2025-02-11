data "vultr_ssh_key" "vultr_ssh_key_pubkey" {
  filter {
    name   = "name"
    values = [var.public_key_name]
  }
}

resource "vultr_instance" "nginx_instance" {
  os_id  = var.vultr_nginx_config.os_id
  plan   = var.vultr_nginx_config.plan
  region = var.vultr_nginx_config.region

  label    = "workshop-02-terraform"
  tags     = ["workshop-02-terraform"]
  hostname = "workshop-02-terraform"

  enable_ipv6         = false
  disable_public_ipv4 = false
  backups             = "disabled"
  ssh_key_ids         = [data.vultr_ssh_key.vultr_ssh_key_pubkey.id]
}

output "vultr_nginx_instance_ipv4" {
  description = "Nginx Server IPv4"
  value       = vultr_instance.nginx_instance.main_ip
}

output "nginx_dns" {
  description = "Nginx DNS"
  value       = "code-${vultr_instance.nginx_instance.main_ip}.nip.io"
}

resource "local_file" "inventories_yaml" {
  filename        = "inventories.yaml"
  file_permission = "0644"
  content = templatefile("inventories.yaml.tftpl", {
    private_key_path       = var.private_key_path
    instance_ip            = vultr_instance.nginx_instance.main_ip
    code_server_password   = var.code_server_password
    code_server_binary_url = var.code_server_binary_url
  })
}