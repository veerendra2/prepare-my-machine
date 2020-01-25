#!/bin/bash
# Author: Veerendra Kakumanu
# Description: A fancy script to install necessary packages in Ubuntu

pro_packages=(
  "systemtap" "iotop"
  "blktrace" "sysdig"
  "sysstat" "linux-tools-common"
  "bcc" "bpftrace"
  "ethtool" "nmap"
  "socat" "schroot"
  "debootstrap" "binwalk"
  "binutils"
)

dev_packages=(
  "bridge-utils" "conntrack"
  "python-dev" "python-scapy"
)

general_packages=(
  "filezilla" "ipcalc"
  "wipe" "htop"
  "vlc" "screen"
  "traceroute" "ssh"
  "secure-delete" "makepasswd"
  "pwgen" "tree"
  "macchanger" "unzip"
)

python_packages=(
  "requests" "thefuck"
  "frida-tools" "beautifulsoup4"
  "ansible" "youtube_dl"
)

dependency_packages=(
  "apt-transport-https" "ca-certificates"
  "curl" "gnupg-agent"
  "software-properties-common"
  "git" "python-pip"
)

declare -A ppa_pkgs=(
  ['atom']="ppa:webupd8team/atom"
  ['wireshark']="ppa:wireshark-dev/stable"
  ['anoise']="ppa:costales/anoise"
)

declare -A custom_scripts_urls=(
  ['httpserver']="https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/httpserver.py"
  ['nettools']="https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/netTools.py"
  ['ssid_list']="https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/ssid_list.py"
  ['pastebin']="https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/pastebin.py"
  ['deauth']="https://raw.githubusercontent.com/veerendra2/wifi-deauth-attack/master/deauth.py"
)

declare -A repos=(
  ['my-utils']="https://github.com/veerendra2/my-utils.git"
  ['veerendra2.github.io']="https://github.com/veerendra2/veerendra2.github.io.git"
  ['prometheus-k8s-monitoring']="prometheus-k8s-monitoring"
  ['my-k8s-applications']="https://github.com/veerendra2/my-k8s-applications.git"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'
LINE='───────────────────────────────────────────────────────────────────────────'
line='.........................................'
trap ctrl_c INT
ctrl_c() {
  tput cnorm
  if [[ -z $(jobs -p) ]]; then
    kill $(jobs -p)
    rm pidfile exitcode
  fi
  exit
}

spinner() {
  spin="\\|/-"
  i=0
  tput civis
  while sudo kill -0 $1 2>/dev/null; do
    i=$(((i + 1) % 4))
    printf "\b${spin:$i:1}"
    sleep 0.09
  done
  tput cnorm
}

install() {
  { sh -c "$1 >> init_my_laptop.log 2>&1 &"'
    echo $! > pidfile
    wait $!
    echo $? > exitcode
    ' &}
  printf "%s %s " $2 "${line:${#2}}"
  spinner "$(cat pidfile)"
  if [ "$(cat exitcode)" != "0" ]; then
    printf "${RED}\b[FAILED]\n${PLAIN}"
  else
    printf "${GREEN}\b[DONE]\n${PLAIN}"
  fi
}

install_pkgs(){
  echo "Installing Packages"
  echo $LINE
  echo "${dependency_packages[*]} ${pro_packages[*]} ${dev_packages[*]} ${general_packages[*]} ${!ppa_pkgs[@]}" | fmt
  echo $LINE
  install "sudo apt-get update" "[*] Updating "
  install "sudo apt-get upgrade -y" "[*] Running Upgrade "
  install "sudo apt-get install ${dependency_packages[*]} -y" "[*] Installing Dependency Packages"
  install "sudo apt-get install ${pro_packages[*]} -y" "[*] Installing Pro Packages"
  install "sudo apt-get install ${dev_packages[*]} -y" "[*] Installing Dev Packages"
  install "sudo apt-get install ${general_packages[*]} -y" "[*] Installing General Packages "
  for i in ${!ppa_pkgs[@]};
  do
    install "sudo add-apt-repository ${ppa_pkgs[$i]}" "[*] Adding ${i} PPA"
    install "sudo apt-get install ${i}" "[*] Installing s${i}"
  done
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - > /dev/null 2>&1
  install 'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"' "[*] Adding Docker PPA"
  install "sudo apt-get update" "[*] Updating"
  install "sudo apt-get install docker-ce docker-ce-cli -y" "[*] Installing Docker"
  install "sudo add-apt-repository ppa:wireshark-dev/stable -y" "[*] Adding Wireshark PPA"
  install "sudo apt-get install wireshark -y" "[*] Installing Wireshark"
  echo "** Configuring Wireshark **"
  sudo groupadd wireshark
  sudo usermod -a -G wireshark $USER
  sudo newgrp wireshark &
  sudo chgrp wireshark /usr/bin/dumpcap
  sudo chmod 750 /usr/bin/dumpcap
  sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
  sudo getcap /usr/bin/dumpcap
}


clone_repos() {
  echo "${YELLOW}Cloning repos${PLAIN}"
  echo $LINE
  echo "${!repos[@]}"
  echo $LINE
  mkdir $HOME/projects
  pushd $HOME/projects
  for i in "${!repos[@]}"; do
    install "git clone ${repos[$i]}" "[*] Cloning $i"
  done
  popd
}

install_scripts() {
  echo "${YELLOW}Downloading custom scripts${PLAIN}"
  echo $LINE
  echo "${!custom_scripts_urls[@]}" | fmt
  echo $LINE
  for i in "${!custom_scripts_urls[@]}"; do
    install "${custom_scripts_urls[$i]}" "[*] Cloning $i"
  done
}

pip_packages() {
  echo "${YELLOW}Installing Python PIP Packages${PLAIN}"

  echo "Downloading dotfile"
  echo $LINE
  install "sudo apt-get update && sudo apt-get install curl feh xclip i3lock ngrep -y", "[*] Installing Installing Dependency Packages for doctfiles"
  for x in .aliases .bash_profiles .bash_prompt .bashrc .curlrc .dockerfunctions .exports .functions .path .screenrc; do
    echo "[*]Downloading to $HOME/$x"
    curl -qo $HOME/$x https://raw.githubusercontent.com/veerendra2/dotfiles/master/$x >/dev/null 2>&1
  done
}

extra() {
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
}

# Call functions according to your requirement
install_pkgs
clone_repos
install_scripts
pip_packages
extra