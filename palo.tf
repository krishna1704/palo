data "panos_system_info" "config" {}

resource "panos_tunnel_interface" "example1" {
    name = "tunnel.5"
    static_ips = ["10.1.1.1/24"]
    comment = "Configured for internal traffic"
    vsys    = "virtual system"
}
resource "panos_ike_gateway" "example" {
    name = "example"
    peer_ip_type = "dynamic"
    interface = "loopback.42"
    pre_shared_key = "secret"
    local_id_type = "ipaddr"
    local_id_value = "10.1.1.1"
    peer_id_type = "ipaddr"
    peer_id_value = "10.5.1.1"
    ikev2_crypto_profile = "myIkeProfile"
    enable_liveness_check = ""
    liveness_check_interval = ""
    enable_passive_mode   = ""
}
    resource "panos_ike_crypto_profile" "example" {
    name = "example"
    dh_groups = ["group1", "group2"]
    authentications = ["md5", "sha1"]
    encryptions = ["des"]
    lifetime_value = 8
    authentication_multiple = 3
}
    resource "panos_ipsec_tunnel" "example" {
    name = "example"
    tunnel_interface = "tunnel.7"
    type    = ""
    anti_replay = true
    ak_ike_gateway = "myIkeGateway"
    ak_ipsec_crypto_profile = "myIkeProfile"
}

    resource "panos_ipsec_crypto_profile" "example" {
    name = "example"
    protocol = ""
    authentications = ["md5", "sha384"]
    encryptions = ["des", "aes-128-cbc"]
    dh_group = "group14"
    lifetime_type = "hours"
    lifetime_value = 4
    lifesize_type = "mb"
    lifesize_value = 1
}

    resource "panos_static_route_ipv4" "example" {
    name = "localnet"
    virtual_router = panos_virtual_router.vr1.name
    destination = "10.1.7.0/32"
    interface = ""
    next_hop = "10.1.7.4"
    admin_distance = ""
    metric = ""
    route_table = ""
    bfd_profile = ""
}

    resource "panos_virtual_router" "vr1" {
    name = "my virtual router"
}
