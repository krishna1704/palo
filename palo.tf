# //data "panos_system_info" "config" {}

# resource "panos_tunnel_interface" "example1" {
#     name = "tunnel.5"
#     static_ips = ["10.1.1.1/24"]
#     comment = "Configured for internal traffic"
#     vsys    = "virtual system"
# }
# resource "panos_ike_gateway" "example" {
#     name = "example"
#     peer_ip_type = "dynamic"
#     interface = "loopback.42"
#     pre_shared_key = "secret"
#     local_id_type = "ipaddr"
#     local_id_value = "10.1.1.1"
#     peer_id_type = "ipaddr"
#     peer_id_value = "10.5.1.1"
#     ikev2_crypto_profile = "myIkeProfile"
#     enable_liveness_check = ""
#     liveness_check_interval = ""
#     enable_passive_mode   = ""
# }
#     resource "panos_ike_crypto_profile" "example" {
#     name = "example"
#     dh_groups = ["group1", "group2"]
#     authentications = ["md5", "sha1"]
#     encryptions = ["des"]
#     lifetime_value = 8
#     authentication_multiple = 3
# }
#     resource "panos_ipsec_tunnel" "example" {
#     name = "example"
#     tunnel_interface = "tunnel.7"
#     type    = ""
#     anti_replay = true
#     ak_ike_gateway = "myIkeGateway"
#     ak_ipsec_crypto_profile = "myIkeProfile"
# }

#     resource "panos_ipsec_crypto_profile" "example" {
#     name = "example"
#     protocol = ""
#     authentications = ["md5", "sha384"]
#     encryptions = ["des", "aes-128-cbc"]
#     dh_group = "group14"
#     lifetime_type = "hours"
#     lifetime_value = 4
#     lifesize_type = "mb"
#     lifesize_value = 1
# }

#     resource "panos_static_route_ipv4" "example" {
#     name = "localnet"
#     virtual_router = panos_virtual_router.vr1.name
#     destination = "10.1.7.0/32"
#     interface = ""
#     next_hop = "10.1.7.4"
#     admin_distance = ""
#     metric = ""
#     route_table = ""
#     bfd_profile = ""
# }

#     resource "panos_virtual_router" "vr1" {
#     name = "my virtual router"
# }

################
# Interfaces
################
resource "panos_virtual_router" "default" {
    name = "my virtual router"
}
resource "panos_tunnel_interface" "partner-tunnel-interface" {
  name    = "tunnel.101"
  comment = "Partner Tunnel Interface"
  static_ips = [
    "6.6.6.6"
  ]
}

resource "panos_virtual_router_entry" "vre-tunnel-101" {
  virtual_router = panos_virtual_router.default.name
  interface      = panos_tunnel_interface.partner-tunnel-interface.name
}

################
# VPN
################
resource "panos_ike_crypto_profile" "partner-ike-crypto-profile" {
  name                    = "partner-ike-crypto-profile"
  dh_groups               = ["group14"]
  authentications         = ["sha512"]
  encryptions             = ["aes-256-cbc"]
  lifetime_value          = 28800
  lifetime_type           = "seconds"
  authentication_multiple = 3
}

resource "panos_ike_gateway" "partner-ike-gw" {
  name                     = "partner-gw"
  interface                = "ethernet1/1"
  version                  = "ikev2"
  auth_type                = "pre-shared-key"
  pre_shared_key           = "CHANGE_ME"
  local_id_type            = "ipaddr"
  local_id_value           = "5.5.5.5"
  peer_ip_type             = "ip"
  peer_ip_value            = "9.9.9.9"
  peer_id_type             = "ipaddr"
  peer_id_value            = "9.9.9.9"
  ikev2_crypto_profile     = panos_ike_crypto_profile.partner-ike-crypto-profile.name
  enable_nat_traversal     = true
  nat_traversal_keep_alive = 60
  disabled                 = true
}

resource "panos_ipsec_crypto_profile" "partner-ipsec-crypto-profile" {
  name            = "partner-ipsec-crypto-profile"
  authentications = ["sha512"]
  encryptions     = ["aes-256-cbc"]
  dh_group        = "group14"
  lifetime_type   = "seconds"
  lifetime_value  = 3600
}

resource "panos_monitor_profile" "partner-tunnel-monitor-profile" {
  name      = "partner-tunnel-monitor-profile"
  interval  = 60
  threshold = 3
  action    = "wait-recover"
}

resource "panos_ipsec_tunnel" "partner-ipsec-tunnel" {
  name                    = "partner-ipsec-tunnel"
  tunnel_interface        = panos_tunnel_interface.partner-tunnel-interface.name
  ak_ike_gateway          = panos_ike_gateway.partner-ike-gw.name
  ak_ipsec_crypto_profile = panos_ipsec_crypto_profile.partner-ipsec-crypto-profile.name
  enable_tunnel_monitor   = true
  tunnel_monitor_profile  = panos_monitor_profile.partner-tunnel-monitor-profile.name
  //tunnel_monitor_proxy_id = panos_ipsec_tunnel_proxy_id_ipv4.partner-proxy-id-monitor.name 
  # Circular reference :(
  //tunnel_monitor_proxy_id       = "partner-tunnel-monitor"
  tunnel_monitor_source_ip      = "6.6.6.6"
  tunnel_monitor_destination_ip = "8.8.8.9"
}

# Interoperability with non PanOS peers.
# Proxy IDs
resource "panos_ipsec_tunnel_proxy_id_ipv4" "partner-proxy-id-1" {
  ipsec_tunnel = panos_ipsec_tunnel.partner-ipsec-tunnel.name
  name         = "partner-1"
  local        = "7.7.7.7/32"
  remote       = "8.0.0.0/8"
  protocol_any = true
}

resource "panos_ipsec_tunnel_proxy_id_ipv4" "partner-proxy-id-monitor" {
  ipsec_tunnel = panos_ipsec_tunnel.partner-ipsec-tunnel.name
  name         = "partner-tunnel-monitor"
  local        = "6.6.6.6"
  remote       = "8.8.8.8"
  protocol_any = true
}
resource "panos_static_route_ipv4" "Static-Route" {
    name = "localnet"
    virtual_router = panos_virtual_router.default.name
    destination = "10.1.7.0/32"
    interface = panos_tunnel_interface.partner-tunnel-interface.name
    next_hop = "10.1.7.4"
    //admin_distance = ""
    metric = "10"
    //route_table = "Unicast"
    //bfd_profile = "Disable BFD"
}
