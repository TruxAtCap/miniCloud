## PROVIDER ##

variable "datacenter" {}
variable "datastore" {}
variable "host" {
  description = "name of the ESX host on which the vSphere is installed"
}
#######################
## VM Hardware SPECS ##
#######################

variable "vm_name" {
  description = "the vm name in the vSphere"
}

variable "vm_folder" {
  description = "The folder in the vSphere where the vm will reside."
# default = "test"
}

variable "nb_cpus"      { default = 2 }
variable "ram_size"     { default = 4096 }
variable "vm_template"  { default = "TPL-RockyTrux-1.2" }
variable "vm_firmware"  { default = "efi" }

######################
## OS CUSTOMIZATION ##
######################

variable "vm_hostname" {
  description = "the hostname of the vm's OS"
  type        = string
  default     = "defaultHostname"
}

variable "vm_domain" {
  description = "the domain name of the vm"
  type        = string
  default     = "caplab.lcl"
}

################
## NETWORKING ##
################

variable "vm_ipv4_addr" {
  description = "ipv4 address of the vm. Leave blank (default) for dhcp lease"
  default     = ""
}

variable "vm_ipv4_netmask" {
  default     = 0
}

variable "vm_ipv4_gateway" {
  default     = ""
}

variable "vm_dns_suffix_list" {
  description = "to have FQDN in the OS hostname the vm_domain isnt enough, you need this"
  default     = ["caplab.lcl"]
}

variable "vm_dns_server_list" {
  default     = [""]
}
