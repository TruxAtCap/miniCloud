data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

variable "datacenter" {}

variable "vm_folder_path" {
  description   = "will create the vm folder in the vSphere"
# default       = "/Simon/test"
}


resource "vsphere_folder" "folder" {
  path          = var.vm_folder_path
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
