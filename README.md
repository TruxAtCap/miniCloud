# Documentation miniCloud

## Versions utilisées : 

kube-version : 1.24.0-0
Ansible : 2.9.27
Rocky Linux v8.5, avec kernel : 4.18.0-348.23.1.el8_5.x86_64
vCenter / ESXi 7

## Set up Procedure au 17/05/2022

- Lancer une nouvelle VM sur le vsphere basée sur TPL_RockyTrux1.1
- attendre l'attribution d'une IP et l'ajouter dans TARGET= dans le setup-ansible.sh
- lancer le setup-ansible.sh,
- modifier le nom de la clef dans users.yml (a scripter)
- dans newHosts deplacer le premier worker en ControlerPlane sans changer son nom
- lancer le playbook users.yml avec -i newHosts
- lancer le playbook install-k8sCluster.yml avec -i newHosts:
- lancer le playbook master.yml
