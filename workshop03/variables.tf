variable "do_key" {
  type      = string
  sensitive = true
}

variable "code_server_password" {
  type      = string
  sensitive = true
}

variable "code_server_binary_url" {
  type    = string
  default = "https://github.com/coder/code-server/releases/download/v4.96.4/code-server-4.96.4-linux-amd64.tar.gz"
}

variable "code_server_binary_folder" {
  type    = string
  default = "code-server-4.96.4-linux-amd64.tar.gz"
}

variable "private_key_path" {
  type      = string
  sensitive = true
}

variable "public_key_name" {
  type    = string
  default = "vultr_key_pub"
}

variable "vultr_nginx_config" {
  type = object({
    plan   = string
    region = string
  })
  default = {
    plan   = "vc2-1c-2gb"
    region = "sgp"
  }
}

