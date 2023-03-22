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

}

module "keyvault" {
  source = "./modules/keyvault"

  location = module.rg.location
  rg_name  = module.rg.rg_name
}

module "security_group" {
  source = "./modules/security_group"

  location       = module.rg.location
  rg_name        = module.rg.rg_name
  pub_ip_address = module.pub_ip.pub_ip_address
}

module "pub_ip" {
  source = "./modules/pub_ip"

  location = module.rg.location
  rg_name  = module.rg.rg_name
}

module "vm" {
  source = "./modules/vm"

  location     = module.rg.location
  rg_name      = module.rg.rg_name
  secret_value = module.keyvault.secret_value
  nic_id       = module.networking.nic_id
}

module "networking" {
  source = "./modules/networking"

  location                   = module.rg.location
  rg_name                    = module.rg.rg_name
  pub_ip_id                  = module.pub_ip.pub_ip_id
  address_prefixes           = module.networking.address_prefixes
  virtual_network_subnet_ids = [module.networking.virtual_network_subnet_ids]
}






