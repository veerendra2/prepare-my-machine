RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PLAIN='\033[0m'


printf "${RED}HELLO${PLAIN}"
#printf $PLAIN

install_graphic_drivers(){
  lspci | grep -i --color 'NVIDIA' > /dev/null 2>&1
  if [ "$?" == "0" ];
  then
    echo "[*] Found NVIDIA Card. Downloading graphic_drivers_install.sh script"
    #curl -qO https://raw.githubusercontent.com/veerendra2/my-utils/master/scripts/graphic_drivers_install.sh > /dev/null 2>&1
    #run_cmd "bash ./graphic_drivers_install.sh" "Installing Nvidia drivers, CUDA, hashcat and aircrack-ng tool"
  fi

}

install_graphic_drivers