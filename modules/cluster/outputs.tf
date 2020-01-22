locals {
  all_hostnames = concat("${openstack_compute_instance_v2.master_node.*.name}", "${openstack_compute_instance_v2.client_node.*.name}", "${openstack_compute_instance_v2.es_ingest_node.*.name}")
  all_hosts_metadata = concat("${openstack_compute_instance_v2.master_node.*.metadata}", "${openstack_compute_instance_v2.data_node.*.metadata}", "${openstack_compute_instance_v2.es_ingest_node.*.metadata}")
  all_hosts_mapped = zipmap(local.all_hostnames, local.all_hosts_metadata)
}

output "cluster_map" {
  value = local.all_hosts_mapped
}