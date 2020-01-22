provider "openstack" {}

resource "openstack_compute_keypair_v2" "instance_keypair" {
  name = "${var.instance_keypair_name}"
}

resource "local_file" "cluster_public_key" {
  content = "${openstack_compute_keypair_v2.cluster_keypair.public_key}"
  filename = "${path.module}/cluster_key.pub"
  file_permission = "644"
}

resource "local_file" "cluster_private_key" {
  content = "${openstack_compute_keypair_v2.cluster_keypair.private_key}"
  filename = "${path.module}/cluster_key.pem"
  file_permission = "600"
}

module "cluster_sg" {
  source      = "../modules/openstack/security_group"
  name        = "cluster_default_sec"
  description = "Security group for managing the cluster"

  egress_rules = [
    {
      description = "TCP egress"
      protocol = "tcp"
    }
  ]

  ingress_rules = [
    {
      description = "TCP ingress"
      protocol = "tcp"
      port = 22
    }
  ]
}

module "cluster_deployment" {
  source = "../modules/cluster"
  cluster_depends_on = ["module.cluster_sg"]
  master_node_count = var.master_node_count
  master_node_name = var.master_node_name
  master_node_flavor = var.master_node_flavor
  client_node_count = var.client_node_count
  client_node_name = var.client_node_name
  client_node_flavor = var.client_node_flavor
  instance_keypair = openstack_compute_keypair_v2.instance_keypair.name
  cluster_net = var.cluster_net
  cluster_subnet = var.cluster_subnet
  instance_username = var.instance_username
  instance_usergroup = var.instance_usergroup
  instance_userpwd = var.instance_userpwd
  local_exec_command = var.local_exec_command
  local_exec_working_dir = var.local_exec_working_dir
  cluster_sec_group = module.cluster_sg.security_group_name
}

resource "null_resource" "cluster_configuration" {
  depends_on = ["module.cluster_deployment"]

  triggers = {
    cluster_hosts = join(",", keys(module.cluster_deployment.cluster_map))
  }

  provisioner "local-exec" {
    command = "ansible-playbook -v -i inventory site.yml"
  }
}