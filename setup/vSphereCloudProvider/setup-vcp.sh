#!/bin/bash

kubectl create -f vcp-namespace-account-role.yml
sleep 3
kubectl create --save-config -f secret-vcp.yml
sleep 3
kubectl create -f enable-vcp.yml
sleep 3
kubectl apply -f storageClass-vcp.yml
sleep 3
kubectl apply -f pvc-vcp.yml
