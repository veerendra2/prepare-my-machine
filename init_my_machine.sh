#!/bin/bash
# Author: Veerendra Kakumanu
# Description: A simple script to install necessary packages in Ubuntu


sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y apt-transport-https ca-certificates \
              curl gnupg-agent \
              software-properties-common \
              git python3 python3-pip

sudo apt-get install -y systemtapiotop pcaputils blktracesysdig \
              sysstatlinux-tools-common bccbpftrace \
              ethtoolnmap socatschroot \
              debootstrapbinwalk binutils \
              bridge-utils conntrack \
              python3-dev python3-scapy \
              filezilla ipcalc \
              wipe htop vlc screen \
              traceroute ssh pv \
              secure-delete makepasswd \
              pwgen tree macchanger unzip p7zip-full

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
wget -O- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo add-apt-repository -y ppa:wireshark-dev/stable
sudo add-apt-repository -y ppa:costales/anoise
sudo apt-get update
sudo apt-get install -y install spotify-client signal-desktop wireshark anoise

sudo snap install atom --classic
sudo snap install bitwarden
sudo snap install pycharm-community --classic
sudo snap install --classic code

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
sudo apt-get install docker-ce docker-ce-cli containerd.io

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
pushd $TEMP_DIR
git clone https://github.com/radareorg/radare2
pushd ./radare2
sys/install.sh
popd
popd

echo "** Install onionshare **"
TEMP_DIR=$(mktemp -d)
pushd $TEMP_DIR
git clone https://github.com/micahflee/onionshare.git
pushd ./onionshare
git checkout tags/v2.2
pip3 install -r install/requirements.txt
./dev_scripts/onionshare-gui
popd
popd

lspci | grep -i --color 'vga\|3d\|2d' | grep -i NVIDIA
if [ $? -eq 0 ]; then
    curl https://raw.githubusercontent.com/veerendra2/my-utils/master/scripts/graphic_drivers_install.sh | bash
fi

echo "** Install & Configure dnscrypt-proxy"
sudo apt-get install -y dnscrypt-proxy
sed -i 's/dns=dnsmasq/#dns=dnsmasq/g' /etc/NetworkManager/NetworkManager.conf
sudo cp /etc/dnscrypt-proxy/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml.original
