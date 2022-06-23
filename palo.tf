################
# Interfaces
################
resource "panos_virtual_router" "default" {
  name = "my virtual router"
}
resource "panos_tunnel_interface" "partner-tunnel-interface" {
  name       = var.tunnel_interface_name
  comment    = var.tunnel_interface_comment
  static_ips = var.tunnel_interface_static_ips
}
resource "panos_virtual_router_entry" "vre-tunnel-101" {
  virtual_router = panos_virtual_router.default.name
  interface      = panos_tunnel_interface.partner-tunnel-interface.name
}

################
# VPN
################
resource "panos_ike_crypto_profile" "partner-ike-crypto-profile" {
  name                    = var.ike_crypto_profile_name
  dh_groups               = var.dh_groups_ike
  authentications         = var.ike_crypto_authentication
  encryptions             = var.ike_crypto_encryption
  lifetime_value          = var.ike_crypto_lifetime_value
  lifetime_type           = var.ike_crypto_lifetime_type
  authentication_multiple = 3
}

resource "panos_ike_gateway" "partner-ike-gw" {
  name                     = var.ike_gateway_name
  interface                = var.ike_interface
  version                  = var.ike_version
  auth_type                = var.ike_auth_type
  pre_shared_key           = var.ike_pre_shared_key
  local_id_type            = var.ike_local_id_type
  local_id_value           = var.ike_local_id_value
  peer_ip_type             = var.ike_peer_ip_type
  peer_ip_value            = var.ike_peer_ip_value
  peer_id_type             = var.ike_peer_id_type
  peer_id_value            = var.ike_peer_id_value
  ikev2_crypto_profile     = panos_ike_crypto_profile.partner-ike-crypto-profile.name
  enable_nat_traversal     = true
  nat_traversal_keep_alive = 60
  disabled                 = true
}

resource "panos_ipsec_crypto_profile" "partner-ipsec-crypto-profile" {
  name            = var.ipsec_crypto_name
  authentications = var.ipsec_crypto_authentications
  encryptions     = var.ipsec_crypto_encryptions
  dh_group        = var.ipsec_crypto_dh_group//[local.environment]
  lifetime_type   = var.ipsec_crypto_lifetime_type
  lifetime_value  = var.ipsec_crypto_lifetime_value
}

resource "panos_monitor_profile" "partner-tunnel-monitor-profile" {
  name      = var.tunnel_monitor_name
  interval  = 60
  threshold = 3
  action    = "wait-recover"
}

resource "panos_ipsec_tunnel" "partner-ipsec-tunnel" {
  name                    = var.ipsec_tunnel_name
  tunnel_interface        = panos_tunnel_interface.partner-tunnel-interface.name
  ak_ike_gateway          = panos_ike_gateway.partner-ike-gw.name
  ak_ipsec_crypto_profile = panos_ipsec_crypto_profile.partner-ipsec-crypto-profile.name
  enable_tunnel_monitor   = true
  tunnel_monitor_profile  = panos_monitor_profile.partner-tunnel-monitor-profile.name
  tunnel_monitor_source_ip      = var.ipsec_tunnel_monitor_source_ip
  tunnel_monitor_destination_ip = var.ipsec_tunnel_monitor_destination_ip
}

# Interoperability with non PanOS peers.
# Proxy ID
resource "panos_ipsec_tunnel_proxy_id_ipv4" "partner-proxy-id-1" {
  ipsec_tunnel = panos_ipsec_tunnel.partner-ipsec-tunnel.name
  name         = var.ipsec_tunnel_id_1_name
  local        = var.ipsec_tunnel_id_1_local
  remote       = var.ipsec_tunnel_id_1_remote
  protocol_any = true
}

resource "panos_ipsec_tunnel_proxy_id_ipv4" "partner-proxy-id-monitor" {
  ipsec_tunnel = panos_ipsec_tunnel.partner-ipsec-tunnel.name
  name         = var.ipsec_tunnel_id_monitor_name
  local        = var.ipsec_tunnel_id_monitor_local
  remote       = var.ipsec_tunnel_id_monitor_remote
  protocol_any = true
}
resource "panos_static_route_ipv4" "Static-Route" {
  name           = var.static_route_ipv4_name
  virtual_router = panos_virtual_router.default.name
  destination    = var.static_route_ipv4_destination
  interface      = panos_tunnel_interface.partner-tunnel-interface.name

}
