resource "vsphere_virtual_machine" "control-plane-node" {
  count               = var.cp_count
  name                = "mc-c${var.k8s_cluster_nb}-cp${count.index + 1}"
  num_cpus            = 2
  memory              = 8192
  folder              = vsphere_folder.folder.path
  guest_id            = data.vsphere_virtual_machine.cp_template.guest_id
  scsi_type           = data.vsphere_virtual_machine.cp_template.scsi_type
  firmware            = var.vm_firmware
  datastore_id        = data.vsphere_datastore.datastore.id
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  sync_time_with_host = false

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  enable_disk_uuid = "true"

  network_interface {
    network_id = data.vsphere_network.InterLAN.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.cp_template.id
    customize {
      linux_options {
        #        host_name = "mc-c${var.k8s_cluster_nb}-${count.index + 1}"
        host_name = "mc-c${var.k8s_cluster_nb}-cp${count.index + 1}"
        domain    = "caplab.lcl"
      }

      network_interface {
        ipv4_address = "192.168.1.${var.cp_ip_start + count.index}"
        ipv4_netmask = 24
      }
      ipv4_gateway    = "192.168.1.1"
      dns_suffix_list = ["caplab.lcl"]
      dns_server_list = ["192.168.1.1"]

    }
  }

  disk {
    label         = "disk0"
    size          = data.vsphere_virtual_machine.cp_template.disks.0.size
    eagerly_scrub = data.vsphere_virtual_machine.cp_template.disks.0.eagerly_scrub
    thin_provisioned  = data.vsphere_virtual_machine.cp_template.disks.0.thin_provisioned
  }

  lifecycle {
    ignore_changes = [annotation]
  }

}
