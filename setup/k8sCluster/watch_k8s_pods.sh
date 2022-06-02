#!/bin/bash

tmp_file="/tmp/watchingpods.tmp"
secs=120

touch $tmp_file

while [ $secs -gt 0 ]
do
  clear
  cat $tmp_file
  ssh kube@192.168.1.33 kubectl get node > $tmp_file
  echo "" >> $tmp_file
  ssh kube@192.168.1.33 kubectl get po -A -o wide >> $tmp_file
  ((secs--))
  sleep 1
done

exit 0
