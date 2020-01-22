resource "openstack_compute_instance_v2" "master_node" {
  count       = var.master_node_count
  name        = "${var.master_node_name}-${count.index + 1}"
  key_pair = data.openstack_compute_keypair_v2.instance_keypair.name
  flavor_name = var.master_node_flavor
  image_id    = data.openstack_images_image_v2.instance_image.id
  network {
    port = openstack_networking_port_v2.cluster_net[count.index].id
  }
  stop_before_destroy = true
  config_drive = true
  user_data    = data.template_cloudinit_config.user_data.rendered
  metadata = {
    instance_name = "${var.master_node_name}-${count.index + 1}"
    cluster_role = "master"
    ansible_host     = openstack_networking_port_v2.master_cluster_net[count.index].all_fixed_ips[0]
    ansible_user     = var.instance_username
    python_bin = "/usr/bin/python3"
  }
}

resource "openstack_compute_instance_v2" "client_node" {
  count       = var.client_node_count
  name        = "${var.client_node_name}-${count.index + 1}"
  key_pair = data.openstack_compute_keypair_v2.instance_keypair.name
  flavor_name = var.master_node_flavor
  image_id    = data.openstack_images_image_v2.instance_image.id
  network {
    port = openstack_networking_port_v2.cluster_net[count.index].id
  }
  stop_before_destroy = true
  config_drive = true
  user_data    = data.template_cloudinit_config.user_data.rendered
  metadata = {
    instance_name = "${var.client_node_name}-${count.index + 1}"
    cluster_role = "client"
    role = "kubernetes"
    ansible_host     = openstack_networking_port_v2.client_cluster_net[count.index].all_fixed_ips[0]
    ansible_user     = var.instance_username
    python_bin = "/usr/bin/python3"
  }
}

resource "null_resource" "cloud_init_wait_master_nodes" {
  count = var.master_node_count

  triggers = {
    instances = openstack_compute_instance_v2.master_node[count.index].id
  }

  connection {
    host = openstack_networking_port_v2.master_cluster_net[count.index].all_fixed_ips[0]
    port = 22
    user = var.instance_username
    password = var.instance_userpwd
    timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /dev/null"
    ]
  }
}

resource "null_resource" "cloud_init_wait_client_nodes" {
  count = var.client_node_count

  triggers = {
    instances = openstack_compute_instance_v2.client_node[count.index].id
  }

  connection {
    host = openstack_networking_port_v2.client_cluster_net[count.index].all_fixed_ips[0]
    port = 22
    user = var.instance_username
    password = var.instance_userpwd
    timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /dev/null"
    ]
  }
}

locals {
  all_hostnames = concat("${openstack_compute_instance_v2.master_node.*.name}", "${openstack_compute_instance_v2.client_node.*.name}", "${openstack_compute_instance_v2.es_ingest_node.*.name}")
  all_hosts_metadata = concat("${openstack_compute_instance_v2.master_node.*.metadata}", "${openstack_compute_instance_v2.data_node.*.metadata}", "${openstack_compute_instance_v2.es_ingest_node.*.metadata}")
  all_hosts_mapped = zipmap(local.all_hostnames, local.all_hosts_metadata)
}

output "cluster_map" {
  value = local.all_hosts_mapped
}