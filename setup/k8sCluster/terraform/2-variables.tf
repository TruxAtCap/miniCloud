# Variables

variable "datacenter" {}
variable "datastore" {}
variable "rocky_template" {}
variable "vm_firmware" {}

variable "k8s_cluster_nb" {}

variable "worker_count" {}
variable "cp_count" {}

variable "worker_ip_start" {}
variable "cp_ip_start" {}

# Secrets variables
variable "host" {}
variable "setup_user" {}
variable "setup_passwd" {}
variable "ssh_key_name" {}
variable "ssh_key_path" {}

