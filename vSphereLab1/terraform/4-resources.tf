resource "vsphere_folder" "folder" {
  path          = "/Simon/miniCloudFolder1"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "rocky1" {
  count               = var.vm_count
  name                = "RockyNode-${count.index}"
  num_cpus            = 2
  memory              = 4096
  folder              = vsphere_folder.folder.path
  guest_id            = data.vsphere_virtual_machine.rocky_template.guest_id
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
  }

  disk {
    label             = "disk0"
#    unit_number       = 0
    size              = data.vsphere_virtual_machine.rocky_template.disks.0.size
#    thin_provisioned  = data.vsphere_virtual_machine.rocky_template.disks.0.thin_provisioned
  }

  lifecycle {
    ignore_changes = [annotation]
  }


  extra_config = {
    "guestinfo.metadata" = base64encode(<<-EOT
      network:
        ethernets:
          ens192:
          dhcp4: true
      local-hostname: hnRocky
      instance-id: iiRocky
      EOT
    )
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata" = base64encode(<<-EOT
      package_update: true
      package_upgrade: false
      ssh_pwauth: true
      EOT
    )
    "guestinfo.userdata.encoding" = "base64"
  }  
}
