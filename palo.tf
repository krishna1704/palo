data "panos_system_info" "config" {}
data "panos_ethernet_interface" "eth1" {
    name = "ethernet1/1"
    vsys = "vsys1"
    mode = "layer3"
    adjust_tcp_mss = true
    ipv4_mss_adjust = "${data.panos_system_info.config.version_major >= 8 ? 42 : 0}"

resource "panos_tunnel_interface" "tunnel" {
    name = "tunnel.1"
    static_ips = ["10.1.1.1/24"]
    comment = "Azure Site-to-Site VPN"
    vsys    = "virtual system"
}
resource "panos_ike_gateway" "IKE" {
    name = "testvpn"
    peer_ip_type = "IP"
    interface = "ethernet1/1"
    pre_shared_key = "secret"
    local_id_type = "none"
    local_id_value = ""
    peer_id_type = "ipaddr"
    peer_id_value = "20.62.109.160"
    ikev2_crypto_profile = "default"
    enable_liveness_check = "true"
    liveness_check_interval = "5"
    enable_passive_mode   = "false"
}
    resource "panos_ike_crypto_profile" "IKE-Crypto" {
    name = "default"
    dh_groups = ["group2"]
    authentications = ["sha256", "sha1"]
    encryptions = ["3des","aes-128-cdc","aes-256-cdc"]
    lifetime_value = 8
    authentication_multiple = 3
}
    resource "panos_ipsec_tunnel" "IPSec-tunnel" {
    name = "site-to-site"
    tunnel_interface = "tunnel.1"
    type    = "Auto key"
    anti_replay = true
    ak_ike_gateway = "testvpn"
    ak_ipsec_crypto_profile = "test"
}

    resource "panos_ipsec_crypto_profile" "IPSec-Crypto" {
    name = "test"
    protocol = "ESP"
    authentications = ["sha256"]
    encryptions = ["aes-256-cbc"]
    dh_group = "no-pfs"
    lifetime_type = "hours"
    lifetime_value = 1
    lifesize_type = "mb"
    lifesize_value = 1
}

    resource "panos_static_route_ipv4" "Static-Routes" {
    name = "vpn-traffic"
    virtual_router = panos_virtual_router.virtual-router.name
    destination = "10.0.0.0/16"
    interface = "tunnel.1"
    next_hop = "none"
    admin_distance = "10"
    metric = "10"
    route_table = "Unicast"
    bfd_profile = "Disable BFD"
}

    resource "panos_virtual_router" "virtual-router" {
    name = "default"
}
