data "vultr_ssh_key" "my_ssh_key" {
  filter {
    name   = "name"
    values = [var.public_key_name]
  }
}

# resource "vultr_instance" "my_instance" {
#     count = var.instance_count
#     plan = var.vultr_plan
#     region = var.vultr_region
#     os_id = 1743
#     label = "day-01-terraform-${count.index}"
#     tags = ["day-01-terraform"]
#     hostname = "day-01-terraform-${count.index}"
#     enable_ipv6 = false
#     disable_public_ipv4 = false
#     backups = "disabled"
#     ssh_key_ids = [data.vultr_ssh_key.my_ssh_key.id]
# }

# output "instance_ipv4" {
#   description = "Instance IPV4"
#   value = join(",", vultr_instance.my_instance[*].main_ip)
# }

# resource "vultr_instance" "my_instance" {
#     for_each = var.servers
#     plan = each.value.size
#     region = each.value.region
#     os_id  = each.value.os_id
#     label = each.key
#     tags = [each.key]
#     hostname = each.key
#     enable_ipv6 = false
#     disable_public_ipv4 = false
#     backups = "disabled"
#     ssh_key_ids = [data.vultr_ssh_key.my_ssh_key.id]
# }

# output "instance_ipv4" {
#   description = "Instance IPV4"
#   value = join(",", [ for d in vultr_instance.my_instance: d.main_ip ])
# }

resource "vultr_instance" "my_instance" {
    count = var.instance_count
    plan = var.vultr_plan
    region = var.vultr_region
    os_id = var.os_id
    label = "day-01-terraform-${count.index}"
    tags = ["day-01-terraform"]
    hostname = "day-01-terraform-${count.index}"
    enable_ipv6 = false
    disable_public_ipv4 = false
    backups = "disabled"
    ssh_key_ids = [data.vultr_ssh_key.my_ssh_key.id]

    connection {
      type = "ssh"
      user = "root"
      private_key = file(var.private_key)
      host = self.main_ip
    }

    provisioner "remote-exec" {
        inline = [ 
            "apt update",
            "apt upgrade -y"
         ]
    }
}

resource "local_file" "name" {
    filename = "vultr_ips.txt"
    content = templatefile("vultr_ips.txt.tftpl", {
        message = "Generated on 10th Feb 2025",
        instance_ipv4 = [ for d in vultr_instance.my_instance: d.main_ip ]
        # instance_ipv4 = vultr_instance.my_instance[*].main_ip
  })
}

output "instance_ipv4" {
  description = "Instance IPV4"
  value = join(",", vultr_instance.my_instance[*].main_ip)
}

output "vultr_ssh_key_id" {
  description = "SSH Key ID"
  value       = data.vultr_ssh_key.my_ssh_key.id
}

output "vultr_ssh_key_pubkey" {
  description = "SSH Pub Key"
  value       = data.vultr_ssh_key.my_ssh_key.ssh_key
}
