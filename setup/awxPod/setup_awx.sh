#!/bin/bash

ansible-playbook kustomize_setup.yml

ansible-playbook awx-operator_setup.yml

ansible-playbook awx_setup.yml

