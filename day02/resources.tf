data "vultr_ssh_key" "my_ssh_key" {
  filter {
    name   = "name"
    values = [var.public_key_name]
  }
}

resource "vultr_instance" "vultr_instance" {
  plan                = var.vultr_plan
  region              = var.vultr_region
  os_id               = var.os_id
  label               = "day-02-terraform"
  tags                = ["day-02-terraform"]
  hostname            = "day-02-terraform"
  enable_ipv6         = false
  disable_public_ipv4 = false
  backups             = "disabled"
  ssh_key_ids         = [data.vultr_ssh_key.my_ssh_key.id]
}

resource "local_file" "inventories-yaml" {
  filename = "inventories.yaml"
  content = templatefile("inventories.yaml.tftpl", {
    private_key   = var.private_key_path
    instance_ipv4 = vultr_instance.vultr_instance.main_ip
  })
}

output "instance_ipv4" {
  description = "Instance IPV4"
  value       = vultr_instance.vultr_instance.main_ip
}

output "vultr_ssh_key_id" {
  description = "SSH Key ID"
  value       = data.vultr_ssh_key.my_ssh_key.id
}

output "vultr_ssh_key_pubkey" {
  description = "SSH Pub Key"
  value       = data.vultr_ssh_key.my_ssh_key.ssh_key
}
