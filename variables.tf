variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = ""
}

variable "subnet_name" {
  description = "The name of the subnet to use in VM scale set"
  default     = ""
}

variable "vpn_gateway_name" {
  description = "The name of the Virtual Network Gateway"
  default     = ""
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic"
  default     = "Dynamic"
}

variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  default     = "Basic"
}

variable "gateway_type" {
  description = "The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute"
  default     = "Vpn"
}

variable "vpn_type" {
  description = "The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased"
  default     = "RouteBased"
}

variable "vpn_gw_sku" {
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments"
  default     = "VpnGw1"
}

variable "expressroute_sku" {
  description = "Configuration of the size and capacity of the virtual network gateway for ExpressRoute type. Valid options are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ and depend on the type, vpn_type and generation arguments"
  default     = "Standard"
}

variable "vpn_gw_generation" {
  description = "The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None"
  default     = "Generation1"
}

variable "enable_active_active" {
  description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false."
  default     = false
}

variable "enable_bgp" {
  description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false"
  default     = true
}

variable "bgp_asn_number" {
  description = "The Autonomous System Number (ASN) to use as part of the BGP"
  default     = "65515"
}

variable "bgp_peering_address" {
  description = "The BGP peer IP address of the virtual network gateway. This address is needed to configure the created gateway as a BGP Peer on the on-premises VPN devices. The IP address must be part of the subnet of the Virtual Network Gateway."
  default     = ""
}

variable "bgp_peer_weight" {
  description = "The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100"
  default     = "10"
}

variable "local_networks" {
  type        = list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string }))
  description = "List of local virtual network connections to connect to gateway"
  //default     = [{ local_gw_name = "onpremise", local_gateway_address = "8.8.8.8", local_address_space = ["10.1.0.0/24", "10.10.0.0/16"], shared_key = "humana" }]
}

variable "local_bgp_settings" {
  type        = list(object({ asn_number = number, peering_address = string, peer_weight = number }))
  description = "Local Network Gateway's BGP speaker settings"
  default     = null
}

variable "gateway_connection_type" {
  description = "The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet)"
  default     = "IPsec"
}

variable "express_route_circuit_id" {
  description = "The ID of the Express Route Circuit when creating an ExpressRoute connection"
  default     = null
}

variable "peer_virtual_network_gateway_id" {
  description = "The ID of the peer virtual network gateway when creating a VNet-to-VNet connection"
  default     = null
}

variable "fw_ip" {
  description = "ip address for palo-alto firewall"
  type        = string
}
variable "username" {
  description = "palo-alto firewall user-name"
  type        = string
}
variable "password" {
  description = "palo-alto firewall password"
  type        = string
}

variable "gateway_connection_protocol" {
  description = "The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2"
  default     = "IKEv2"
}

variable "local_networks_ipsec_policy" {
  description = "IPSec policy for local networks. Only a single policy can be defined for a connection."
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

############PALO-ALTO#################

variable "tunnel_interface_name" {
  description = "The interface's name. This must start with tunnel."
  type        = string
}
variable "tunnel_interface_comment" {
  description = "The interface comment"
  type        = string
}
variable "tunnel_interface_static_ips" {
  description = "IPv4 addresses to set for this data interface"
  type        = list(any)
}

variable "dh_groups_ike" {
  description = "DH Group entries. Values should have a prefix if group"
  type        = list(any)
}
variable "ike_crypto_profile_name" {
  description = "The object's name of ike_crypto"
  type        = string

}
variable "ike_crypto_encryption" {
  description = "List of encryption types. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, and aes-256-cbc."
  type        = list(any)
}
variable "ike_crypto_authentication" {
  description = "authentication types. md5,sha1,sha128,sha256"
  type        = list(any)
}
variable "ike_crypto_lifetime_type" {
  description = "The lifetime type. Valid values are seconds, minutes, hours (the default), and days."
  type        = string
  default     = "hours"
}
variable "ike_crypto_lifetime_value" {
  description = "The lifetime value."
  type        = string
}
variable "ike_gateway_name" {
  description = "The object's name of IKE Gateway"
  type        = string
}
variable "ike_interface" {
  description = "The interface comment of IKE Gateway"
  type        = string
}
variable "ike_version" {
  description = "The IKE gateway version. Valid values are ikev1, (the default), ikev2, or ikev2-preferred. For PAN-OS 6.1, only ikev1 is acceptable."
  type        = string
}
variable "ike_auth_type" {
  description = "The auth type. Valid values are pre-shared-key (the default), or certificate"
  type        = string
}
variable "ike_pre_shared_key" {
  description = "The pre-shared key value of IKE Gateway"
  type        = string
}
variable "ike_local_id_type" {
  description = "The local ID type. Valid values are ipaddr, fqdn, ufqdn, keyid, or dn"
  type        = string
}
variable "ike_local_id_value" {
  description = "The local ID value."
  type        = string
}
variable "ike_peer_ip_type" {
  description = "The peer ip type. Valid values are ipaddr, fqdn, ufqdn, keyid, or dn"
  type        = string
}
variable "ike_peer_ip_value" {
  description = "The peer ip value."
  type        = string
}
variable "ike_peer_id_type" {
  description = "The peer ID type."
  type        = string
}
variable "ike_peer_id_value" {
  description = "The peer ID value."
  type        = string
}
variable "ipsec_crypto_name" {
  description = "The object's name of IPSec Crypto"
  type        = string
}
variable "ipsec_crypto_authentications" {
  description = "List of authentication types.md5,sha1,sha128,sha256"
  type        = list(any)
}
variable "ipsec_crypto_encryptions" {
  description = "List of encryption types. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, aes-256-cbc, aes-128-gcm, aes-256-gcm, and null"
  type        = list(any)
}
variable "ipsec_crypto_dh_group" {
  description = "The DH group value. Valid values should start with the string group"
  type        = string
}
variable "ipsec_crypto_lifetime_type" {
  description = "The lifetime type. Valid values are seconds, minutes, hours"
  type        = string
  default     = "hours"
}
variable "ipsec_crypto_lifetime_value" {
  description = "The lifetime value."
  type        = string
}
variable "tunnel_monitor_name" {
  description = "The monitor profile name"
  type        = string
}
variable "ipsec_tunnel_name" {
  description = "The object's name of the Tunnel"
  type        = string
}
variable "ipsec_tunnel_monitor_source_ip" {
  description = "Source IP of Tunnel_monitor"
  type        = string
}
variable "ipsec_tunnel_monitor_destination_ip" {
  description = "Tunnel Monitor Destination IP to send ICMP"
  type        = string
}
variable "ipsec_tunnel_id_1_name" {
  description = "The object's name of IPSec tunnel id_1"
  type        = string
}
variable "ipsec_tunnel_id_1_local" {
  description = "IP subnet or IP address represents local network"
  type        = string
}
variable "ipsec_tunnel_id_1_remote" {
  description = "IP subnet or IP address represents remote network"
  type        = string
}
variable "ipsec_tunnel_id_monitor_name" {
  description = "The object's name of IPSec tunnel id Monitor"
  type        = string
}
variable "ipsec_tunnel_id_monitor_local" {
  description = "IP subnet or IP address represents local network of Monitor id"
  type        = string
}
variable "ipsec_tunnel_id_monitor_remote" {
  description = "IP subnet or IP address represents remote network Monitor Id"
  type        = string
}
variable "static_route_ipv4_name" {
  description = "The static route's name."
  type        = string
}
variable "static_route_ipv4_destination" {
  description = "Destination IP address / prefix"
  type        = string
}
