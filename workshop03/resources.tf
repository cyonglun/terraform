data "vultr_ssh_key" "vultr_ssh_key_pubkey" {
  filter {
    name   = "name"
    values = [var.public_key_name]
  }
}

resource "vultr_instance" "nginx_instance" {
  plan              = var.vultr_nginx_config.plan
  region            = var.vultr_nginx_config.region
  snapshot_id       = "6090d673-9eb6-4588-b3e8-39c46962ccfb" # snapshot id from vultr snapshots
  firewall_group_id = "32d05e84-9c36-41a1-9c09-45297d360ebe"

  label    = "workshop-03-terraform"
  tags     = ["workshop-03-terraform"]
  hostname = "workshop-03-terraform"

  enable_ipv6         = false
  disable_public_ipv4 = false
  backups             = "disabled"
  ssh_key_ids         = [data.vultr_ssh_key.vultr_ssh_key_pubkey.id]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.private_key_path)
    host        = self.main_ip
    timeout     = "20m"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/__REPLACE__/${var.code_server_password}/' /etc/systemd/system/code-server.service",
      "sed -i 's/__REPLACE__/code-server.${self.main_ip}.nip.io/' /etc/nginx/sites-available/code-server.conf",
      "systemctl daemon-reload",
      "systemctl restart code-server.service",
      "systemctl restart nginx"
    ]
  }
}

output "vultr_nginx_instance_ipv4" {
  description = "Nginx Server IPv4"
  value       = vultr_instance.nginx_instance.main_ip
}

output "nginx_dns" {
  description = "Nginx DNS"
  value       = "code-${vultr_instance.nginx_instance.main_ip}.nip.io"
}