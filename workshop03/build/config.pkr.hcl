 packer {
   required_plugins {
    ansible = {
      version = ">=v1.1.2"
      source = "github.com/hashicorp/ansible"
    }
     vultr = {
       version = ">=v2.5.0"
       source = "github.com/vultr/vultr"
     }
   }
 }