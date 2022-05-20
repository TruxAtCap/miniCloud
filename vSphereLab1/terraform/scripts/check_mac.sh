#!/bin/bash

username="setupuser"
iplist=(192.168.1.3{3..5})

for ip in ${iplist[@]}; do
  
  echo -e "\nFor machine $ip"
  sshpass -f .check_mac_passwd ssh -o StrictHostKeyChecking=no $username@$ip hostname 
  sshpass -f .check_mac_passwd ssh -o StrictHostKeyChecking=no $username@$ip "ip a | grep link/ether"
done
