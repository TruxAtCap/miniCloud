resource "vsphere_virtual_machine" "server" {
# count               = 1
  name                = var.vm_name
  num_cpus            = var.nb_cpus
  memory              = var.ram_size
# folder              = vsphere_folder.folder.path
  folder              = var.vm_folder
  guest_id            = data.vsphere_virtual_machine.vm_template.guest_id
  scsi_type           = data.vsphere_virtual_machine.vm_template.scsi_type
  datastore_id        = data.vsphere_datastore.datastore.id
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  firmware            = var.vm_firmware

  sync_time_with_host = false
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  enable_disk_uuid    = "true"
# vm_ipv4_start       = var.vm_ipv4_start 

  network_interface {
    network_id = data.vsphere_network.InterLAN.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.vm_template.id
    customize {
      linux_options {
        host_name = var.vm_hostname
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = var.vm_ipv4_addr
        ipv4_netmask = var.vm_ipv4_netmask
      }
      ipv4_gateway    = var.vm_ipv4_gateway
#     dns_suffix_list = ["caplab.lcl"]
      dns_suffix_list = var.vm_dns_suffix_list
#     dns_server_list = ["192.168.1.1"]
      dns_server_list = var.vm_dns_server_list
    }
  }

  disk {
    label         = "disk0"
    size          = data.vsphere_virtual_machine.vm_template.disks.0.size
    eagerly_scrub = data.vsphere_virtual_machine.vm_template.disks.0.eagerly_scrub
  }

  lifecycle {
    ignore_changes = [annotation]
  }
}
