#!/bin/bash

CUR_USER=`whoami`
echo "[*] Add $CUR_USER to sudoer"
echo "$CUR_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$CUR_USER

sudo apt-get update
sudo apt-get install -y git python3 python3-pip \
    apt-transport-https ca-certificates \
    curl gnupg lsb-release

pip3 install ansible
mkdir -p ~/projects
pushd ~/projects
git clone git@github.com:veerendra2/init-my-ubuntu.git
pushd init-my-ubuntu

echo "***************** Starting Ansible Playbook *****************"
#exec ansible-playbook main.yml --tags=$1
