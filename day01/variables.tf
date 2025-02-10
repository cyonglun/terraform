variable DO_KEY {
    type = string
    description = "DO Key"
    default = "changeit"
    sensitive = true
}

variable public_key_name {
    type = string
    default = "vultr_key_pub"  
}

variable "private_key" {
    type = string
    sensitive = true
}

variable "instance_count" {
    type = number
    default = 2
}

variable "vultr_plan" {
  type = string
  default = "vc2-1c-1gb"
}

variable "os_id" {
  type = number
  default = 2284
}

variable "vultr_region" {
    type = string
    default = "mia"
}

variable "servers" {
  type = map(
    object({
        size = string
        os_id = number
        region = string
    })
  )
  default = {
    "myserver-1gb" = {
      size = "vc2-1c-1gb"
      os_id = 2284
      region = "mia"
    },
    "myserver-2gb" = {
      size = "vc2-1c-2gb"
      os_id = 2284
      region = "sea"
    },
  }
}