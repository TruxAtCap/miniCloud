#!/bin/bash

touch /tmp/watchingpods.tmp

while true
do
  clear
  cat /tmp/watchingpods.tmp
  ssh kube@192.168.1.33 kubectl get po -A -o wide > /tmp/watchingpods.tmp
  sleep 1

done
