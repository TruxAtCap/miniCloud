#!/bin/bash

ansible-playbook pv_postgres_deploy.yml

ansible-playbook kustomize_setup.yml

ansible-playbook awx-operator_setup.yml

ansible-playbook awx_setup.yml

echo -e "\nNow, need to edit the persistent volume claim of the postgres db with\n\n \
      kubectl edit pvc postgres-awx-test-postgres-0\n\n \
and add the parameter in the \"spec:\" at the same indent than \"resources:\" \n\n \
      volumeName : \"pv-postgres\" \n"
