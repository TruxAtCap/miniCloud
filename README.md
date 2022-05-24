# Projet : miniCloud

### Le projet miniCloud est un service de mise à disposition automatisé de machines virtuelles.

L'installation de miniCloud est automatisée avec Terraform et Ansible pour pouvoir etre facilement déployé ou mis à l'echelle en fonction des besoins, grace à son architecture basé sur un cluster Kubernetes. 

Le **service proposé** par miniCloud :
- Préparation de templates d'images de machines virtuelles pour VMware vSphere avec Packer
- Choix de l'utilisateur des ressources souhaitées sur l'interface utilisateur AWX
- Déploiement de ces machines virtuelles avec à Terraform dans le vSphere
- Eventuel paramettrage ultérieur (automatisé si besoin) grace à Ansible
- Mise à disposition de l'utilisateur des ressources à travers le serveur de rebond "Guacamole
- Tableau de bord pour observation et controle des ressources utilisées pour l'administrateur (Kubernetes)

<br>

---

<br>

###  Comment ça marche ?
<br>

![miniCloudByMathieu.png](https://github.com/TruxAtCap/miniCloud/blob/main/img/miniCloud.png?raw=true)

- Point de depart : Une VM "controller" (Rocky Linux 8.5) dans le vCenter v7
- Déploiement et préparation des VMs necessaire à la mise en place du cluster Kubernetes, "Control Plane nodes" et "Workers nodes", avec Terraform et Ansible.
- Initialisation du cluster Kubernetes avec Ansible.
- Mise en place du pod AWX qui sera l'interface utilisateur permettant de demander des ressources (VMs) préconfigurées par Packer (à l'avenir configurable en live)
- Mise en place du pod Packer.
- Mise en place du déploiement automatique d'un pod Terraform controllant le cycle de vie de chaque VM, ce pod étant controllé par AWX.

Et voilà, miniCloud est installé et prêt à livrer des machines virtuelles ! 

<br>
<br>

# Technique




## Installation : au 24/05/2022

- Lancer une nouvelle VM sur le vsphere basée sur TPL_RockyTrux1.1 (à généraliser avec un template Packer)
- faire un git pull du projet. 
- Renseigner les bon credentials du vSphere pour Terraform, Ansible et Packer
- definir le nombre de control plane nodes / worker nodes ainsi que leurs plages d'adresses IP 
dans miniCloud/vSphereLab1/terraform/

A UPDATER APRES REFONTE DU GIT TREE
- dans newHosts deplacer le premier worker en ControlerPlane sans changer son nom
- lancer le playbook users.yml avec -i newHosts
- lancer le playbook install-k8sCluster.yml avec -i newHosts:
- lancer le playbook master.yml
- lancer le playbook join-nodes.yml


```
git directory tree a refaire (en cours...):
|- setup/
   |- packerTemplates/ ?
   |- K8sCluster/
      |- terraform/
      |- ansible/
   |- AWXPod/
   |- PackerPod/
   |- TerraPod ? (or in AWX ?)
|- packer/
   |- VMtemplates ?

|- img/
   |- miniCloud.png
  
```

---
## Versions : 
```
VMController : Rocky Linux 8.5 / kernel : 4.18.0-348.23.1.el8_5.x86_64
vCenter / ESXi / vSphere 7.0

kubernetes : 1.24.0-0
containerd.io CRI : 1.6.4-3.1.el8 
calico CNI: 
Ansible : 2.9.27
Terraform : 1.2.0-1 / 1.1.9-1 
Packer : 1.8.0
```
