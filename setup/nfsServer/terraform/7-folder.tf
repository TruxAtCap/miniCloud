resource "vsphere_folder" "folder" {
  path          = "/Simon/storage"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
