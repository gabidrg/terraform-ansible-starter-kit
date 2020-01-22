data "openstack_networking_secgroup_v2" "cluster_sec_group" {
  name = var.cluster_sec_group
}

data "openstack_networking_network_v2" "cluster_net" {
  name = var.cluster_net
}

data "openstack_networking_subnet_v2" "cluster_subnet" {
  name = var.cluster_subnet
}

data "openstack_images_image_v2" "instance_image" {
  name        = var.instance_image
  most_recent = true
}

data "openstack_compute_keypair_v2" "instance_keypair" {
  name = "${var.instance_keypair}"
}

data "template_file" "cloud_config" {
  template = file("${path.module}/templates/user_data.tpl")

  vars = {
    username  = var.instance_username
    usergroup = var.instance_usergroup
    userpwd   = var.instance_userpwd
    publickey = data.openstack_compute_keypair_v2.instance_keypair.public_key
  }
}

data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config.rendered
  }
}