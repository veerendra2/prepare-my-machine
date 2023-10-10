#!/usr/bin/env bash

set -e

CUR_USER=`whoami`
echo "[*] Add $CUR_USER to sudoer"
echo "$CUR_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/custom

if [ "$(uname -s)" == "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install python3 pipx
    curl https://bootstrap.pypa.io/get-pip.py | python3

else
    sudo apt-get update
    sudo apt-get install -y git python3 python3-pip \
        apt-transport-https ca-certificates \
        curl gnupg lsb-release python3.10-venv
    export PATH="$HOME/.local/bin/:$PATH"
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
fi
echo "[*] Install ansible"
pip3 install jmespath ansible

if [[ $(basename `git rev-parse --show-toplevel`) != "prepare-my-machine" ]]; then
    echo "in the if"
    mkdir -p ~/projects
    pushd ~/projects > /dev/null
    ssh-keyscan github.com >> ~/.ssh/known_hosts
    if [ -d "prepare-my-machine" ]; then
        git clone https://github.com/veerendra2/prepare-my-machine.git
    fi
    pushd prepare-my-machine > /dev/null
fi
echo "Here"
ansible-galaxy install --force -r requirements.yml
echo "***************** Starting Ansible Playbook *****************"
ansible-playbook main.yml
