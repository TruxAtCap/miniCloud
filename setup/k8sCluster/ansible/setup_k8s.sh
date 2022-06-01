#!/bin/bash

echo -e "\nSetting up firewalld config.\n"
ansible-playbook k8s_firewalld.yml

echo -e "\nDifferent preps for k8s cluster. \n"
ansible-playbook k8s_preps.yml

echo -e "\nInitializing Control Plane Node \n"
ansible-playbook k8s_init_master.yml

echo -e "\nJoining Workers to the Cluster \n"
ansible-playbook k8s_join_workers.yml
