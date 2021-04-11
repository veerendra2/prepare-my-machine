#!/bin/bash
echo "-------- Stating Installing Packages --------"
sudo apt-get update
sudo apt-get install -y git python3 python3-pip \
    apt-transport-https \
    ca-certificates \
    curl ansible\
    gnupg \
    lsb-release
pip3 install -y ansible
mkdir ~/projects
echo "***************** Starting Ansible Playbook *****************"
ansible init_my_machine.yaml 
