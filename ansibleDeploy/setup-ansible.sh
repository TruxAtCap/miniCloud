#!/bin/bash
TARGETS=(192.168.1.145)
KEYNAME="MCc1Keytest2"
KEYPATH="/home/trux/.ssh/$KEYNAME"
USER="setupuser"

set -x

echo -e "\nSetting up ansible\n"

echo "Checking hosts connectivity with ping"
for ip in ${TARGETS[@]}; do
  if ping -c 1 $ip &>/dev/null; then
    echo $ip : PING OK
  else
    echo $ip : No Ping : Machine Unreachable.
    echo Exiting now
    exit 1
  fi
done;

if ! [ -f $KEYPATH ]; then
  echo -e "\nGenerating ssh key named $KEYNAME\n"
  ssh-keygen -b 4096 -f $KEYPATH -P ""
else
  echo -e "\nThe Key $KEYPATH already exists\n"
fi

sleep 1

echo -e "\nSending the key to each hosts"
for ip in ${TARGETS[@]}; do  
  sleep 1
  sshpass -f setuppasswd.txt ssh-copy-id -i $KEYPATH.pub $USER@$ip
#  sshpass -f setuppasswd.txt ssh-keyscan -H $i >> /home/trux/.ssh/known_hosts
done

#definir shortcut  SSHEXE
SSHEXE="ssh -o StrictHostKeyChecking=no -i $KEYPATH $USER@$ip"

echo -e "\nChanging sshd_config parametters"
for ip in ${TARGETS[@]}; do
  sshpass -f setuppasswd.txt $SSHEXE 'sudo sed -i s/PermitRootLogin\ yes/PermitRootLogin\ no/g /etc/ssh/sshd_config'
  sshpass -f setuppasswd.txt $SSHEXE 'sudo sed -i s/PasswordAuthentication\ yes/PasswordAuthentication\ no/g /etc/ssh/sshd_config'
done

sleep 2
# Find a way to make hostname a variable
echo -e "\nChanging hostname, and installing python3\n"
for ip in ${TARGETS[@]}; do
  sshpass -f setuppasswd.txt $SSHEXE 'sudo hostnamectl set-hostname worker.caplab.lcl'
  sshpass -f setuppasswd.txt $SSHEXE 'sudo dnf install python3 -y'
done

# Preparing hostfile before populating
HOSTFILE="./newHosts"
echo -e "[ControlPlane]\n\n[Workers]" > $HOSTFILE

echo -e "\nAdding <ip> <name> in /etc/hosts and matching host with key in ~/.ssh/config and adding fingerprintto known_hosts"

i="3"
for ip in ${TARGETS[@]}; do
  # POPULATING /etc/hosts/ FILE
  grep $ip /etc/hosts || echo "$ip worker$i" | sudo tee -a /etc/hosts
  # Mathing host with key locally to get rid of ssh '-i'
  grep worker$i /home/trux/.ssh/config || echo -e "\nMatch host=worker$i \n  IdentitiesOnly yes\n  IdentityFile $KEYPATH" | sudo tee -a /home/trux/.ssh/config
  # adding host fingerprint to known_hosts
  ssh-keyscan -H worker$i >> /home/trux/.ssh/known_hosts
  #POPULATING ansible HOSTFILE
  echo "worker$i ansible_user=$USER" >> $HOSTFILE

  ((i++))
done

#echo -e "\nRestarting sshd service on remote hosts\n"
#sleep 1
#for ip in ${TARGETS[@]}; do
#  sshpass -f setuppasswd.txt $SSHEXE 'sudo systemctl restart sshd'
#done

sleep 5

echo "---"
echo "Final step, checking target hosts with ansible ping :"
echo "---"

ansible all -i $HOSTFILE -m ping
