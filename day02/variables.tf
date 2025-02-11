variable "DO_KEY" {
  type        = string
  description = "DO Key"
  default     = "changeit"
  sensitive   = true
}

variable "public_key_name" {
  type    = string
  default = "vultr_key_pub"
}

variable "private_key_path" {
  type      = string
  sensitive = true
}

variable "vultr_plan" {
  type    = string
  default = "vc2-1c-1gb"
}

variable "os_id" {
  type    = number
  default = 2284
}

variable "vultr_region" {
  type    = string
  default = "sgp"
}
