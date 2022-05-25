#!/bin/bash
set -x

PASSWD=$(cat ./.setuppasswd)

echo -e "Setting up the ansible connection with remote hosts. \n"
echo -e "Pinging now"

ansible all -m ping --extra-vars "ansible_user=setupuser ansible_password=$PASSWD"
echo -e "\nSetting up "kube" sudoers account on remote hosts"
ansible-playbook make_user.yml --extra-vars "ansible_user=setupuser ansible_password=$PASSWD"


