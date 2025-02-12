source vultr nginx_snapshot {
    api_key              = "${var.vultr_token}"
    os_id                = "${var.vultr_nginx_config.os_id}"
    plan_id              = "${var.vultr_nginx_config.plan}"
    region_id            = "${var.vultr_nginx_config.region}"
    snapshot_description = "${var.nginx_snapshot_name}"
    ssh_username         = "root"
    state_timeout        = "25m"
}

build {
    sources = ["source.vultr.nginx_snapshot"]

    provisioner ansible {
        playbook_file = "playbook.yaml"
        extra_arguments = [
            "--extra-vars",
            "code_server_binary_url=${var.code_server_binary_url} code_server_binary_folder=${var.code_server_binary_folder}"
        ]
    }
}