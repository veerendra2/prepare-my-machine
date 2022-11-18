#!/bin/bash
# https://github.com/veerendra2/ubuntu-dev

if [ "$1" == "" ]
then
    echo "Usage: run.sh cli|desktop|all"
    exit 1
fi

echo "***************** Stating Installing Packages *****************"
CUR_USER=`whoami`
echo "[*] Add $CUR_USER to sudoer"
echo "$CUR_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$CUR_USER

sudo apt-get update
sudo apt-get install -y git python3 python3-pip \
    apt-transport-https \
    ca-certificates \
    curl ansible\
    gnupg \
    lsb-release
pip3 install ansible
mkdir -p ~/projects
git clone https://github.com/veerendra2/ubuntu-dev.git ~/projects/ubuntu-dev
pushd ~/projects/ubuntu-dev

echo "***************** Starting Ansible Playbook *****************"
exec ansible-playbook main.yml --tags=$1
