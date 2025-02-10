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

  label    = "workshop-01-terraform"
  tags     = ["workshop-01-terraform"]
  hostname = "workshop-01-terraform"

  enable_ipv6         = false
  disable_public_ipv4 = false
  backups             = "disabled"
  ssh_key_ids         = [data.vultr_ssh_key.vultr_ssh_key_pubkey.id]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.private_key)
    host        = self.main_ip
  }

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt upgrade -y",
      "apt install nginx -y",
      "systemctl enable nginx",
      "systemctl start nginx",
    ]
  }

  provisioner "file" {
    source      = "assets/"
    destination = "/var/www/html"
  }
}

output "vultr_nginx_instance_ipv4" {
  description = "Nginx Server IPv4"
  value       = vultr_instance.nginx_instance.main_ip
}

resource "local_file" "nginx_dns" {
  filename        = "nginx-${vultr_instance.nginx_instance.main_ip}.nip.io"
  file_permission = "0444"
  content         = ""
}

resource "local_file" "index_html" {
  filename        = "assets/index.html.tfpl"
  file_permission = "0644"
  content = templatefile("assets/index.html.tfpl", {
    instance_ip = vultr_instance.nginx_instance.main_ip
  })
}