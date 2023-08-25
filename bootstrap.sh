#!/usr/bin/env bash

set -e

CUR_USER=`whoami`
echo "[*] Add $CUR_USER to sudoer"
echo "$CUR_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/custom

if [ "$(uname -s)" == "Darwin" ]; then
    macos_steps
else
    linux_steps
fi
echo "[*] Install ansible"
pip3 install ansible

mkdir -p ~/projects
pushd ~/projects > /dev/null
git https://github.com/veerendra2/prepare-my-machine.git
pushd dotfiles > /dev/null
git pull

ansible-galaxy install --force -r requirements.yml
echo "***************** Starting Ansible Playbook *****************"
exec ansible-playbook main.yml


function linux_steps() {
    apt-get update
    apt-get install -y git python3 python3-pip \
        apt-transport-https ca-certificates \
        curl gnupg lsb-release
}

function macos_steps(){
    echo "[*] Install homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "[*] Install python3"
    brew install python3

    echo "[*] Install pip3"
    curl https://bootstrap.pypa.io/get-pip.py | python3
}
