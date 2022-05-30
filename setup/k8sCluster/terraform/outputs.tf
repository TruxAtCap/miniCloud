# Example output query
#output "worker_node_name" {
#  description = "name of each worker vm for ansible setup"
#  value       = vsphere_virtual_machine.worker-node.*.name
#}

# One way to do it with quest_ip_addresses
#output "control_plane_ip_list" {
#  description = "list of ip of control plane nodes"
#  value       = vsphere_virtual_machine.control-plane-node.*.guest_ip_addresses
#}

output "ControlPlane" {
  description = "list of ip of control plane nodes"
  value       = vsphere_virtual_machine.control-plane-node.*.clone.0.customize.0.network_interface.0.ipv4_address
}

output "Workers" {
  description = "list of ip of worker nodes"
  value       = vsphere_virtual_machine.worker-node.*.clone.0.customize.0.network_interface.0.ipv4_address
}
