resource "openstack_networking_port_v2" "master_cluster_net" {
  count          = var.master_node_count
  name           = "${var.master_node_name}-${count.index + 1}.cluster_net"
  network_id     = data.openstack_networking_network_v2.cluster_net.id
  admin_state_up = "true"

  security_group_ids = [
    data.openstack_networking_secgroup_v2.cluster_sec_group.id,
  ]

  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.cluster_subnet.id
  }
}

resource "openstack_networking_port_v2" "client_cluster_net" {
  count          = var.client_node_count
  name           = "${var.client_node_name}-${count.index + 1}.cluster_net"
  network_id     = data.openstack_networking_network_v2.cluster_net.id
  admin_state_up = "true"

  security_group_ids = [
    data.openstack_networking_secgroup_v2.cluster_sec_group.id,
  ]

  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.cluster_subnet.id
  }
}