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
pipx install --include-deps ansible

if [[ $(git remote get-url origin 2>/dev/null) != "https://github.com/veerendra2/prepare-my-machine.git" ]]; then
    mkdir -p ~/projects
    pushd ~/projects > /dev/null
    ssh-keyscan github.com >> ~/.ssh/known_hosts
    git clone https://github.com/veerendra2/prepare-my-machine.git
    pushd prepare-my-machine > /dev/null
fi

ansible-galaxy install --force -r requirements.yml
echo "***************** Starting Ansible Playbook *****************"
ansible-playbook main.yml
