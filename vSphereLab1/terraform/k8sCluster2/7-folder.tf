resource "vsphere_folder" "folder" {
  path          = "/Simon/miniCloud-Cluster${var.k8s_cluster_nb}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
