rocky_template = "TPL-RockyTrux1.1"
datacenter     = "OVH"
datastore      = "OVH_NVME2"
vm_firmware    = "efi"

# vm names impacted by
k8s_cluster_nb = 3

cp_count     = 1
worker_count = 1

# last ip byte only
cp_ip_start     = 33
worker_ip_start = 35
