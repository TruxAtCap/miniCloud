#!/bin/bash
#set -x

PASSWD=$(cat ./.setuppasswd)
KEYNAME="TestKey42" #Has got to match with the one in make_user.yml
KEYPATH="/home/trux/.ssh/$KEYNAME"

echo -e "Setting up the ansible connection with remote hosts. \n"
echo -e "Pinging now with setupuser credentials."
ansible all -m ping --extra-vars "ansible_user=setupuser ansible_password=$PASSWD"

if ! [ -f $KEYPATH ]; then
  echo -e "\nGenerating new ssh key pair named $KEYNAME\n"
  ssh-keygen -b 4096 -f $KEYPATH -P ""
else
  echo -e "\nThe key pair $KEYPATH already exists and will be used.\n"
fi

echo -e "\nSetting up "kube" sudoer account on remote hosts"
ansible-playbook make_user.yml --extra-vars "ansible_user=setupuser ansible_password=$PASSWD"


#
# REGLER LA PARTIE SUIVANTE POUR ADAPTER AU NOUVEAU HOSTS FILE
# GENERE PAR TERRAFORM

# Recuperation de la liste des ips dans le "hosts" de ansible
echo -e "\nGathering hosts IPs and adding them on local ~/.ssh/config with matching key\n"
hostfile="../terraform/TerraHosts"
for ip in $(grep '^[1-2]' $hostfile | cut -d " " -f1); do 
  ip_host_list+=$ip
  ip_host_list+=","
done
# Ajout des ips dans config si absent pour que ansible sache quelle cle utiliser
grep $ip_host_list /home/trux/.ssh/config || echo -e "\nMatch host=$ip_host_list \n  IdentitiesOnly yes\n  IdentityFile $KEYPATH" | sudo tee -a /home/trux/.ssh/config

#
# JUSQUE ICI
#


# Suppression du setupUser
echo -e "\nSuppression du setupuser\n"
ansible-playbook del_setupuser.yml

# Peuplement du /etc/hosts de chaque machine 
# a adapter aussi en localhost ? et avec le FQDN
echo -e "\nAjout du /etc/hosts sur chaque machine\n"
ansible-playbook make_etc_hosts.yml
