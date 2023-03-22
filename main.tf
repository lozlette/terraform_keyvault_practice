terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.47.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

module "rg" {
  source = "./modules/rg"

  rg_location = module.rg.rg_location
  rg_name = module.rg.rg_name
}

module "keyvault" {
  source = "./modules/keyvault"

  secret_id = module.keyvault.secret_id
  secret_value = module.keyvault.secret_value
  kv_id = module.keyvault.kv_id
}

module "security_group" {
  source = "./modules/security_group"
}

module "pub_ip" {
  source = "./modules/pub_ip"
}

module "vm" {
  source = "./modules/vm"
}

module "networking" {
  source = "./modules/networking"
}






