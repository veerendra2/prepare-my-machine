#!/bin/bash
# Author: Veerendra Kakumanu
# Description: Installs necessary packages in Ubuntu


trap ctrl_c INT
ctrl_c() {
# Courtesy https://github.com/adtac/climate/blob/master/climate
    tput cnorm
    if [[ -z $(jobs -p) ]]; then
        kill $(jobs -p)
    fi
    exit
}

spinner() {
# Courtesy https://github.com/adtac/climate/blob/master/climate
    spin="\\|/-"
    i=0
    tput civis
    while sudo kill -0 $1 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\b${spin:$i:1}"
        sleep 0.07
    done
    tput cnorm
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

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

declare -A custom_scripts_urls=(
  ['my-utils']="https://github.com/veerendra2/my-utils.git"
  ['veerendra2.github.io']="https://github.com/veerendra2/veerendra2.github.io.git"
  ['prometheus-k8s-monitoring']="prometheus-k8s-monitoring"
  ['my-k8s-applications']="https://github.com/veerendra2/my-k8s-applications.git"
)

function install_dep_first() {
  sudo apt-get update >> one_installer.log 2>&1 &
  printf "Installing dependency_packages"
  spinner $!
  sudo apt-get install $dependency_packages -y >> one_installer.log 2>&1 &
  printf "Installing dependency_packages"
  spinner $!
}
install_dep_first
