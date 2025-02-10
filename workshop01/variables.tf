variable "do_key" {
  type      = string
  sensitive = true
}

variable "private_key" {
  type      = string
  sensitive = true
}

variable "public_key_name" {
  type    = string
  default = "vultr_key_pub"
}

# variable "vultr_os_id" {
#   type    = number
#   default = 2284
# }

# variable "vultr_plan" {
#   type    = string
#   default = "vc2-1c-1gb"
# }

# variable "vultr_region" {
#   type    = string
#   default = "sgp"
# }

variable "vultr_nginx_config" {
  type = object({
    os_id  = number
    plan   = string
    region = string
  })
  default = {
    os_id  = 2284
    plan   = "vc2-1c-1gb"
    region = "sgp"
  }
}