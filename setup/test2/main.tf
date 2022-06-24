
# Having to call the folder module once first, then populate it with vms
module "folder1" {
  source    = "/home/trux/miniCloud/setup/modulesTerra/folder"
  
  datacenter      = "OVH"
  vm_folder_path = "/Simon/test3"
}

module "test_server2" {
  source = "/home/trux/miniCloud/setup/modulesTerra/server_tpl2"

      ## vSphere VM specs ##
  count           = 2
  datacenter      = "OVH"
  datastore       = "OVH_NVME2"
  host            = "esx01.caplab.lcl"
  vm_name         = "Test-srv2-${count.index + 1}"
  vm_folder       = "/Simon/test3" 

      ## Customization of OS ##
  vm_hostname     = "Test-srv2-${count.index + 1}"
  vm_domain       = "caplab.lcl"
  # vm_template     = "TPL-RockyTrux-1.2"

      ## Networking optional settings ##
# vm_ipv4_addr    = ""
# vm_ipv4_netmask = 0
# vm_ipv4_gateway = ""
# vm_dns_suffix_list  = [""]
# vm_dns_server_list  = [""]
}
