module "resource-group" {
  source              = "../childmodule/azure_resource_group"
  resource_group_name = "dev1rg"
  location            = "us"
}

module "virtual-network" {
  depends_on           = [module.resource-group]
  source               = "../childmodule/azure_vnet"
  resource_group_name  = "dev2001rg"
  location             = "Westus"
  virtual_network_name = "dev2001vnet"   # 👈 match with VM
  address_space        = ["10.0.0.0/16"]
}

module "subnet" {
  depends_on           = [module.virtual-network]
  source               = "../childmodule/azure_subnet"
  resource_group_name  = "dev2001rg"
  virtual_network_name = "dev2001vnet"   # 👈 match with VNET
  subnet_name          = "dev201subnet"  # 👈 match with VM
  address_prefixes     = ["10.0.2.0/24"]
}

module "public-ip" {
  depends_on          = [module.resource-group]
  source              = "../childmodule/azure_pip"
  resource_group_name = "dev2001rg"
  location            = "Westus"
  public_ip_name      = "dev2001pip"     # 👈 match with VM
}

module "key_vault" {
  depends_on          = [module.resource-group]
  source              = "../childmodule/azure_keyvault"
  key_vault_name      = "keyvault911"
  resource_group_name = "dev2001rg"
  location            = "Westus"
}

module "keyvaultsecret" {
  depends_on          = [module.key_vault]
  source              = "../childmodule/azure_keyvaultsecret" # 👈 alag module banao
  key_vault_name      = "keyvault911"
  resource_group_name = "dev2001rg"
 
}

module "virtual-machine" {
  depends_on = [
    module.resource-group,
    module.virtual-network,
    module.subnet,
    module.public-ip,
    module.key_vault,
    module.keyvaultsecret
  ]

  source               = "../childmodule/azure_vm"
  resource_group_name  = "dev2001rg"
  location             = "Westus"
  vm_name              = "dev201vm"
  virtual_network_name = "dev2001vnet"
  subnet_name          = "dev201subnet"
  public_ip_name       = "dev2001pip"
  nic_name             = "dev2001-nic"
  key_vault_name       = "keyvault911"
  username_secret_name = "vm-admin-username"
  password_secret_name = "vm-admin-password"
}
