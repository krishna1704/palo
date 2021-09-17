module "vpn-gateway" {
  source  = "https://github.com/krishna1704/palo"
  version = "1.0.0"

  # Resource Group, location, VNet and Subnet details
  # IPSec Site-to-Site connection configuration requirements
  resource_group_name  = ""
  virtual_network_name = ""
  vpn_gateway_name     = ""
  gateway_type         = "Vpn"

  # local network gateway connection 
  local_networks = [
    {
      local_gw_name         = "onpremise"
      local_gateway_address = ""
      local_address_space   = [""]
      shared_key            = ""
    },
  ]

  # Adding TAG's to your Azure resources (Required)
  tags = {
    ProjectName  = ""
    Env          = ""
    Owner        = ""
    BusinessUnit = ""
    ServiceClass = ""
  }
}
