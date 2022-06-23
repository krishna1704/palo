fw_ip                               = "52.179.137.203"
username                            = "palo-admin"
password                            = "Pspalopoc!2021"
tunnel_interface_name               = "tunnel.2"
tunnel_interface_comment            = "Site-to-Site"
tunnel_interface_static_ips         = ["8.8.8.8"]
ike_crypto_profile_name             = "partner-ike-crypto-profile"
dh_groups_ike                       = ["group1", "group2", "group5", "group14", "group15", "group16", "group19", "group20", "group21", "group24"]
ike_crypto_authentication           = ["md5", "sha1", "sha128", "sha256"]
ike_crypto_encryption               = ["des", "3des", "aes-128-cbc", "aes-192-cbc", "aes-256-cbc"]
ike_crypto_lifetime_value           = "28800"
ike_crypto_lifetime_type            = "seconds"
ike_gateway_name                    = "partner-gw"
ike_interface                       = "ethernet1/1"
ike_version                         = "ikev2"
ike_auth_type                       = "pre-shared-key"
ike_pre_shared_key                  = "CHANGE_ME"
ike_local_id_type                   = "ipaddr"
ike_local_id_value                  = "5.5.5.5"
ike_peer_ip_type                    = "ip"
ike_peer_ip_value                   = "8.8.8.8"
ike_peer_id_type                    = "ipaddr"
ike_peer_id_value                   = "8.8.8.8"
ipsec_crypto_name                   = "partner-ipsec-crypto-profile"
ipsec_crypto_authentications        = ["md5", "sha1", "sha128", "sha256"]
ipsec_crypto_encryptions            = ["des", "3des", "aes-128-cbc", "aes-192-cbc", "aes-256-cbc"]
ipsec_crypto_dh_group               = "group14"
ipsec_crypto_lifetime_type          = "seconds"
ipsec_crypto_lifetime_value         = "3600"
tunnel_monitor_name                 = "tunnel-monitor-profile"
ipsec_tunnel_name                   = "partner-ipsec-tunnel"
ipsec_tunnel_monitor_source_ip      = "8.8.8.9"
ipsec_tunnel_monitor_destination_ip = "5.5.5.5"
ipsec_tunnel_id_1_name              = "partner-1"
ipsec_tunnel_id_1_local             = "7.7.7.7/32"
ipsec_tunnel_id_1_remote            = "8.0.0.0/8"
ipsec_tunnel_id_monitor_name        = "partner-tunnel-monitor"
ipsec_tunnel_id_monitor_local       = "6.6.6.6"
ipsec_tunnel_id_monitor_remote      = "8.8.8.8"
static_route_ipv4_name              = "localnet"
static_route_ipv4_destination       = "10.1.7.0/32"


##################SITE-TO-SITE######################
# Resource Group, location, VNet and Subnet details
# IPSec Site-to-Site connection configuration requirements
resource_group_name  = "test-rg"
virtual_network_name = "test-vnet"
vpn_gateway_name     = "Azure_vnet_gateway"
gateway_type         = "Vpn"

# local network gateway connection 
local_networks = [
  {
    local_gw_name         = "onpremise"
    local_gateway_address = "8.8.8.8"
    local_address_space   = ["10.1.0.0/24"]
    shared_key            = "xpCGkHTBQmDvZK9HnLr7DAvH"
  },
]

# Adding TAG's to your Azure resources (Required)
tags = {
  ProjectName  = "palo-alto"
  Env          = "dev"
  Owner        = "humana.com"
  BusinessUnit = "automation"
  ServiceClass = "networking"
}
