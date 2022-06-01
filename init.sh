#!/bin/bash

ClusterPath="setup/k8sCluster"

echo -e "\nWelcome to miniCloud init script.\n"
echo -e "Starting to terraform the kubernetes cluster now.\n"

terraform -chdir=$ClusterPath/terraform apply -auto-approve

echo -e "\nSetting up Ansible.\n"

cd $ClusterPath/ansible
./setup_ansi.sh

echo -e "\nInitializing Kubernetes Cluster\n"
./setup_k8s.sh
