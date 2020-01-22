variable "instance_keypair_name" {
  description = "Name of the key-pair to be used for deployment"
  default     = "cluster-test"
}

variable "master_node_count" {
  description = "Number of master nodes to be deployed"
  default     = 1
}

variable "client_node_count" {
  description = "Number of client nodes to be deployed"
  default     = 1
}

variable "master_node_name" {
  description = "Prefix for master node hosts"
  default     = "master"
}

variable "client_node_name" {
  description = "Prefix for client node hosts"
  default     = "client"
}

variable "master_node_flavor" {
  description = "Flavor for master nodes"
  default     = "2C-4GB-50GB"
}

variable "client_node_flavor" {
  description = "Flavor for client nodes"
  default     = "2C-4GB-50GB"
}

variable "instance_image" {
  description = "Instance image to be used"
  default     = "Ubuntu 18.04 Bionic Beaver"
}

variable "instance_username" {
  description = "Username for administrative account to be created"
  default     = "administrator"
}

variable "instance_usergroup" {
  description = "Usergroup for administrative account to be created"
  default     = "administrator"
}

variable "instance_userpwd" {
  description = "Password for administrative account to be created"
  default     = "administrator"
}

variable "cluster_net" {
  description = "Network to use for the cluster"
  default     = "cluster_net"
}

variable "cluster_subnet" {
  description = "Subnet to use for the cluster"
  default     = "cluster_subnet"
}

variable "cluster_sec_group" {
  description = "Security group for the deployed cluster"
  default = "cluster_sec"
}

variable "local_exec_command" {
  description = "Command to be executed by local_exec provisioner after all instances have finished cloud-init stage."
  default = ""
}

variable "local_exec_working_dir" {
  description = "Working directory for local_exec provisioner"
  default = "./"
}

variable "cluster_depends_on" {
  description = "Dependency list for module"
  type = any
  default = null
}