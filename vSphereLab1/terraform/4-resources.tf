resource "vsphere_folder" "folder" {
  path          = "/Simon/miniCloudFolder1"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "rocky1" {
  count               = var.vm_count
  name                = "mc-cTest-${count.index + 1}"
  num_cpus            = 2
  memory              = 4096
  folder              = vsphere_folder.folder.path
  guest_id            = data.vsphere_virtual_machine.rocky_template.guest_id
  scsi_type           = data.vsphere_virtual_machine.rocky_template.scsi_type
  firmware            = var.vm_firmware 
  datastore_id        = data.vsphere_datastore.datastore.id
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  sync_time_with_host = false

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0


  network_interface {
    network_id  = data.vsphere_network.InterLAN.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.rocky_template.id
    customize {
      linux_options {
        host_name = "mc-cTest${count.index + 1}"
        domain    = "caplab.lcl"
      }

      network_interface {
        ipv4_address = "192.168.1.${count.index + 34}"
        ipv4_netmask = 24
      }
      ipv4_gateway      = "192.168.1.1"
      dns_server_list  = ["192.168.1.1"]
    }
  }

  disk {
    label             = "disk0"
#    unit_number       = 0
    size              = data.vsphere_virtual_machine.rocky_template.disks.0.size
    eagerly_scrub     = data.vsphere_virtual_machine.rocky_template.disks.0.eagerly_scrub
#    thin_provisioned  = data.vsphere_virtual_machine.rocky_template.disks.0.thin_provisioned
  }

  lifecycle {
    ignore_changes = [annotation]
  }
}
