
# Having to call the folder module once first, then populate it with vms
module "folder1" {
  source    = "../../mod_folder"
  
  datacenter      = "OVH"
  vm_folder_path = "/Simon/${basename(path.cwd)}"
}

variable "vm_ipv4_start" {
  description     = "last octect of ipv4 address that is the first of the ip pool needed"
# default         = 41
}

module "tpl_server" {
  source = "../../mod_server"

      ## vSphere VM specs ##
  count           = 2
  datacenter      = "OVH"
  datastore       = "OVH_NVME2"
  host            = "esx01.caplab.lcl"
  vm_name         = "${basename(path.cwd)}-${count.index + 1}"
  vm_folder       = "/Simon/${basename(path.cwd)}" 

      ## Customization of OS ##
  vm_hostname     = "${basename(path.cwd)}-${count.index + 1}"
  vm_domain       = "caplab.lcl"
  # vm_template     = "TPL-RockyTrux-1.2"

      ## Networking optional settings ##
# vm_ipv4_addr    = "192.168.1.${var.vm_ipv4_start + count.index}"
# vm_ipv4_netmask = 24
# vm_ipv4_gateway = "192.168.1.1"
  vm_dns_suffix_list  = ["caplab.lcl"]
  vm_dns_server_list  = ["192.168.1.1"]
}
