#!/bin/bash
# Author: Veerendra Kakumanu
# Description: A simple script to install necessary packages in Ubuntu


apt-get update && apt-get upgrade -y

apt-get install -y apt-transport-https ca-certificates \
              curl gnupg-agent \
              software-properties-common \
              git python3 python3-pip

apt-get install -y systemtapiotop pcaputils blktracesysdig \
              sysstatlinux-tools-common bccbpftrace \
              ethtoolnmap socatschroot \
              debootstrapbinwalk binutils \
              bridge-utils conntrack \
              python3-dev python3-scapy \
              filezilla ipcalc \
              wipe htop vlc screen \
              traceroute ssh pv ncdu\
              secure-delete makepasswd gfceu\
              pwgen tree macchanger unzip p7zip-full \
              qemu-kvm libvirt-daemon-system libvirt-clients


adduser `id -un` libvirt
adduser `id -un` kvm

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add -
echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
wget -O- https://updates.signal.org/desktop/apt/keys.asc | apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | tee -a /etc/apt/sources.list.d/signal-xenial.list
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
add-apt-repository -y ppa:wireshark-dev/stable
add-apt-repository -y ppa:costales/anoise
apt-get update
apt-get install -y install spotify-client signal-desktop wireshark anoise vagrant

snap install bitwarden
snap install --classic code

gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

echo "** Configure Wireshark **"
groupadd wireshark
usermod -a -G wireshark $USER
newgrp wireshark &
chgrp wireshark /usr/bin/dumpcap
chmod 750 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
getcap /usr/bin/dumpcap

echo "** Install Docker **"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io

pip3 install requests thefuck frida-tools beautifulsoup4 ansible youtube_dl spotify-cli-linux

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

chmod +x /usr/local/bin/httpserver
chmod +x /usr/local/bin/netTools
chmod +x /usr/local/bin/ssid_list
chmod +x /usr/local/bin/pastebin
chmod +x /usr/local/bin/deauth

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

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
install minikube /usr/local/bin/

echo "** Install & Configure dnscrypt-proxy"
apt-get install -y dnscrypt-proxy
sed -i 's/dns=dnsmasq/#dns=dnsmasq/g' /etc/NetworkManager/NetworkManager.conf
cp /etc/dnscrypt-proxy/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml.original
