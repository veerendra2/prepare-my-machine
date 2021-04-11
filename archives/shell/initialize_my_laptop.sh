#!/bin/bash
# Author: Veerendra Kakumanu
# Description: A simple script to install necessary packages in Ubuntu


sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y apt-transport-https ca-certificates \
              curl gnupg-agent \
              software-properties-common \
              git python3 python3-pip

sudo apt-get install -y systemtapiotop blktracesysdig \
              sysstatlinux-tools-common bccbpftrace \
              ethtoolnmap socatschroot \
              debootstrapbinwalk binutils \
              bridge-utils conntrack \
              python3-dev python3-scapy \
              filezilla ipcalc \
              wipe htop vlc screen \
              traceroute ssh \
              secure-delete makepasswd \
              pwgen tree macchanger unzip p7zip-full

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo add-apt-repository ppa:webupd8team/atom
sudo add-apt-repository ppa:wireshark-dev/stable
sudo add-apt-repository ppa:costales/anoise

sudp apt-get update
sudo apt-get install -y install spotify-client atom wireshark anoise

echo "** Configure Wireshark **"
sudo groupadd wireshark
sudo usermod -a -G wireshark $USER
sudo newgrp wireshark &
sudo chgrp wireshark /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
sudo getcap /usr/bin/dumpcap

echo "** Install Docker **"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
udo apt-get install docker-ce docker-ce-cli containerd.io

pip3 install requests thefuck frida-tools beautifulsoup4 ansible youtube_dl

mkdir $HOME/projects
pushd $HOME/projects
git clone https://github.com/veerendra2/my-utils.git
git clone https://github.com/veerendra2/veerendra2.github.io.git
git clone https://github.com/veerendra2/dotfiles
popd

wget -qO /usr/local/bin/httpserver https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/httpserver.py
wget -qO /usr/local/bin/netTools https://raw.githubusercontent.com/veerendra2/my-utils/master/tools/netTools.py
wget -qO /usr/local/bin/ssid_list https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/ssid_list.py
wget -qO /usr/local/bin/pastebin https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/pastebin.py
wget -qO /usr/local/bin/deauth https://raw.githubusercontent.com/veerendra2/wifi-deauth-attack/master/deauth.py

sudo chmod +x /usr/local/bin/httpserver
sudo chmod +x /usr/local/bin/netTools
sudo chmod +x /usr/local/bin/ssid_list
sudo chmod +x /usr/local/bin/pastebin
sudo chmod +x /usr/local/bin/deauth

curl https://raw.githubusercontent.com/veerendra2/dotfiles/master/install.sh | bash

echo "** Install Radare2 **"
TEMP_DIR=$(mktemp -d)
pushd TEMP_DIR
install "git clone git clone https://github.com/radareorg/radare2" "[*] Cloning radare2"
pushd ./radare2
install "sys/install.sh" "[*]Build and install radare2"
popd
popd

TEMP_DIR=$(mktemp -d)
pushd TEMP_DIR
install "git clone https://github.com/micahflee/onionshare.git" "[*] Cloning OnionShare"
install "git checkout tags/v2.2" "[*]Checkout tags/v2.2"
pushd ./onionshare
install "pip3 install -r install/requirements.txt" "[*] Installing Dependencies"
install "./dev_scripts/onionshare-gui" "[*] Installing OnionShare"
popd
popd
