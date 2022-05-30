resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
    ansi_user         = "kube",
    cp_number         = range(var.cp_count),
    worker_number     = range(var.worker_count),
    control_plane_ip  = vsphere_virtual_machine.control-plane-node.*.clone.0.customize.0.network_interface.0.ipv4_address
    worker_ip         = vsphere_virtual_machine.worker-node.*.clone.0.customize.0.network_interface.0.ipv4_address
#    guest_ip_test     = vsphere_virtual_machine.control-plane-node.*.guest_ip_addresses
#    guest_ip_test  = vsphere_virtual_machine.control-plane-node.*.clone.0.customize.0.network_interface.0.ipv4_address
    }
  )
  filename  = "TerraHosts"
}
