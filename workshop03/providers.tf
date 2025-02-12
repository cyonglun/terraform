terraform {
  required_version = ">= 1.10.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    vultr = {
      source  = "vultr/vultr"
      version = "2.23.1"
    }
  }
}

provider "local" {
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.do_key
  rate_limit  = 100
  retry_limit = 3
}