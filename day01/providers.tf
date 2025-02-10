terraform {
  required_version = ">= 1.10.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
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

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "local" {
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.DO_KEY
  rate_limit  = 100
  retry_limit = 3
}

# # Pulls the image
# resource "docker_image" "ubuntu" {
#   name = "ubuntu:latest"
# }

# # Create a container
# resource "docker_container" "foo" {
#   image = docker_image.ubuntu.image_id
#   name  = "foo"
# }