#!/bin/bash

ansible-playbook pv_postgres_deploy.yml

ansible-playbook kustomize_setup.yml

ansible-playbook awx-operator_setup.yml

ansible-playbook awx_setup.yml

