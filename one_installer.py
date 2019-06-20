#!/usr/bin/env python
'''
@author: Veerendra Kakumanu
@summary: Installs  packages for Ubuntu 14
'''
import os
import subprocess
import sys
import itertools
import logging
from logging.handlers import RotatingFileHandler

HEADER = '\033[95m'
OKBLUE = '\033[94m'
OKGREEN = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
ENDC = '\033[0m'
BOLD = '\033[1m'
UNDERLINE = '\033[4m'
hostname = os.uname()[1]
base_path = os.path.dirname(os.path.abspath(__file__))
summary = dict()
levels = {"info": logging.INFO, "critical": logging.CRITICAL}
LOG_LOCATION = '/var/log/one_installer.log'
MAX_SIZE_LOG = 20 #Mega Bytes
BACKUP_COUNT = 0
spin = itertools.cycle("|/-\\")
handler = RotatingFileHandler(LOG_LOCATION, mode='a', maxBytes=MAX_SIZE_LOG*1024*1024, backupCount=BACKUP_COUNT, encoding=None, delay=0)
log = logging.getLogger('one_installer')

update = {"update": "apt-get update",
          "upgrade": "apt-get upgrade -y"
          }

commands = {
            "atom_ppa": "sudo add-apt-repository ppa:webupd8team/atom -y",
            "atom_install": "sudo apt-get install atom -y",

            "deb_utils": "sudo apt-get install -y python-software-properties debconf-utils",
            "ppa_jdk8": "sudo add-apt-repository ppa:webupd8team/java -y",
            "jdk_debcon_select": "echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | debconf-set-selections",
            "jdk_debcon_seen": "echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections",
            "jdk_install": "apt-get install -y oracle-java8-installer",

            "wireshark_ppa": "sudo add-apt-repository ppa:wireshark-dev/stable -y",
            "wireshark_install": "apt-get install -y wireshark --force-yes",
            "lib_install": "apt-get install libcap2-bin -y",

            "pinta_ppa": "sudo add-apt-repository ppa:pinta-maintainers/pinta-stable -y",
            "pinta_install": "apt-get install pinta -y",

            "onionShare_ppa": "sudo add-apt-repository ppa:micahflee/ppa -y",
            "onion_install": "sudo apt-get install onionshare -y",

            "tor_ppa": "sudo add-apt-repository -y ppa:webupd8team/tor-browser",
            "tor_install": "sudo apt-get install tor-browser -y"
            }

custom_scripts_urls = {
    "youtube-dl": "https://yt-dl.org/downloads/latest/youtube-dl",
    "httpserver": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/httpserver.py",
    "nettools": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/netTools.py",
    "ssid_list": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/ssid_list.py",
    "pastebin": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/pastebin.py",
    "deauth": "https://raw.githubusercontent.com/veerendra2/wifi-deauth-attack/master/deauth.py"
}

repos_links = [
    "https://github.com/veerendra2/useless-scripts.git",

]

pro_packages = [
    "systemtap", "iotop",
    "blktrace", "sysdig",
    "sysstat", "linux-tools-common",
    "bcc", "bpftrace",
    "ethtool", "nmap",
    "socat", "schroot",
    "debootstrap", "binwalk",
    "binutils"
]

dev_packages = [
    "python3-pip", "python-pip",
    "bridge-utils", "contrack",
    "python-dev", "python-scapy"
]

general_packages = [
    "filezilla", "curl",
    "wipe", "htop",
    "vlc", "screen",
    "traceroute", "ssh",
    "secure-delete", "makepasswd",
    "pwgen", "tree",
    "macchanger", "unzip",
    "ipcalc"
]

python_packeages = [
    "requests", "thefuck",
    "frida-tools", "beautifulsoup4",
    "ansible", "funmotd"
]

'''
vim packages
$ cd ~/
$ git clone --recursive https://github.com/jessfraz/.vim.git .vim
$ ln -sf $HOME/.vim/vimrc $HOME/.vimrc
$ cd $HOME/.vim
$ git submodule update --init

https://github.com/tsl0922/ttyd
https://github.com/itsKindred/procSpy

- radara
- https://github.com/jedisct1/dnscrypt-proxy/wiki/Installation-on-Debian-and-Ubuntu

'''

def log_it(level, message):
    log.setLevel(levels[level])
    log.addHandler(handler)
    handler.setLevel(levels[level])
    if level == "info":
        log.info(message)
    elif level == "critical":
        log.critical(message)


def execuiteCommand(msg, cmd, verbose=True):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out = []
    if verbose:
        print "{}".format(msg).ljust(30, "."),
    while True:
        line = p.stdout.readline()
        out.append(line)
        log_it("info", p.stdout.readline().strip())
        if verbose:
            sys.stdout.write("\b{}".format(next(spin)))
            sys.stdout.flush()
        if not line and p.poll() is not None:
            break
    if p.returncode != 0:
        if verbose:
            print FAIL+"\b[ FAILED ]"+ENDC
        log_it("critical", p.stderr.read().strip())
        return 1
    else:
        if verbose:
            print OKGREEN+"\b[ DONE ]"+ENDC
        log_it("info", "--- COMPLETED----")
        return ''.join(out).strip()


def onionShare():
    execuiteCommand(commands["onionShare_ppa"])
    execuiteCommand()
    execuiteCommand(commands["onion_install"])
    summary["Onion Share"] = "Success"


def youtube_downloader():
    execuiteCommand(commands["Youtube-dll"])
    execuiteCommand(commands["Permissions"])


def pinta():
    execuiteCommand(commands["pinta_ppa"])
    execuiteCommand()
    execuiteCommand(commands["pinta_install"])
    summary["Pinta"] = "Success"


def atom():
    execuiteCommand(commands["atom_ppa"])
    execuiteCommand()
    execuiteCommand(commands["atom_install"])
    summary["Atom"] = "Success"

def installWireshark():
    execuiteCommand(commands["lib_install"])
    execuiteCommand(commands["wireshark_ppa"])
    execuiteCommand()
    execuiteCommand(commands["wireshark_install"])
    print bcolors.OKBLUE + "Configuring Wireshark..." + bcolors.ENDC
    execuiteCommand("groupadd wireshark")
    cur_user = execuiteCommand("w | grep init | awk {'print $1'}").strip()
    execuiteCommand("sudo usermod -a -G wireshark {}".format(cur_user))
    execuiteCommand("sudo newgrp wireshark &")
    execuiteCommand("sudo chgrp wireshark /usr/bin/dumpcap")
    execuiteCommand("sudo chmod 750 /usr/bin/dumpcap")
    execuiteCommand("sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap")
    execuiteCommand("sudo getcap /usr/bin/dumpcap")


def installDocker(ubuntu_version=14):
    if ubuntu_version == 14:
        repo_link = "deb https://apt.dockerproject.org/repo ubuntu-trusty main"
    elif ubuntu_version == 12:
        repo_link = "deb https://apt.dockerproject.org/repo ubuntu-precise main"
    elif ubuntu_version == 16:
        repo_link = "deb https://apt.dockerproject.org/repo ubuntu-xenial main"

    if not os.path.exists("/etc/apt/sources.list.d/docker.list"):
        with open("/etc/apt/sources.list.d/docker.list", "w") as f:
            f.write(repo_link)
    execuiteCommand(commands["docker_certificate"])
    execuiteCommand(commands["docker_keys"])
    execuiteCommand()
    execuiteCommand(commands["docker_install"])
    if verifyInstaller("docker --version", "Docker"):
        summary["Docker"] = "Success"
        print bcolors.OKGREEN + "Docker installed successfully!" + bcolors.ENDC
        execuiteCommand("docker pull veerendrav2/hacker-tools")
    else:
        summary["Docker"] = "Failed"


def installGrubCustomizer():
    execuiteCommand(commands["grub_repo"])
    execuiteCommand()
    execuiteCommand(commands["grub_install"])
    summary["Grub Customizer"] = "Success"


def installJDK():
    if verifyInstaller("java -version", "java version "):
        summary["JDK8"] = "Already Installed"
    else:
        execuiteCommand(commands["deb_utils"])
        execuiteCommand(commands["ppa_jdk8"])
        execuiteCommand()
        execuiteCommand(commands["jdk_debcon_select"])
        execuiteCommand(commands["jdk_debcon_seen"])
        execuiteCommand(commands["jdk_install"])
        if verifyInstaller("java -version", "java version"):
            summary["JDK8"] = "Success"
            print bcolors.OKGREEN + "JDK8 installed successfully!" + bcolors.ENDC
        else:
            summary["JDK8"] = "Failed"
            print bcolors.FAIL + "JDK8 installation failed" + bcolors.ENDC


def installPkgs():
    execuiteCommand()
    for pkg, cmd in packages.items():
        print bcolors.OKBLUE + "Installing {} \n***************************".format(pkg) + bcolors.ENDC
        execuiteCommand(cmd)
        print bcolors.OKGREEN + "Done! \n" + bcolors.ENDC


def setMotd():
    execuiteCommand("wget -q -O /etc/motd https://goo.gl/tCpJrR")
    with open("/etc/motd", "r") as f:
        lines = f.readlines()
    lines[0] = "\n>> {} MACHINE\n".format(hostname.upper())
    with open("/etc/motd", "w") as f:
        f.writelines(lines)


def install_Tor_Browser():
    execuiteCommand(commands["tor_ppa"])
    execuiteCommand()
    execuiteCommand(commands["tor_install"])


def install_changer():
    execuiteCommand()
    execuiteCommand(commands["macchanger"])
    execuiteCommand("wget -q -O /etc/init.d/changer https://goo.gl/tRfoJo")
    execuiteCommand("sudo chmod +x /etc/init.d/changer")
    execuiteCommand("sudo update-rc.d changer defaults")


def installAll():
    execuiteCommand(update["update"])
    execuiteCommand(update["upgrade"])
    installPkgs()
    installDocker()
    installEclipse()
    installWireshark()
    installAtom()
    installGrubCustomizer()
    setMotd()
    installPinta()
    install_changer()
    install_Youtube_Downloader()
    install_onionShare()
    install_Tor_Browser()
    print bcolors.BOLD + bcolors.OKBLUE + "\n***** Summary of Installation *****" + bcolors.ENDC
    for k, v in summary.items():
        if "Skip" in v:
            print k.ljust(15, " "), ":", bcolors.WARNING + v + bcolors.ENDC
        elif v == "Failed":
            print k.ljust(15, " "), ":", bcolors.FAIL + v + bcolors.ENDC
        elif v == "Success":
            print k.ljust(15, " "), ":", bcolors.OKGREEN + v + bcolors.ENDC
    execuiteCommand("notify-send 'One Installer' 'Installation Completed!'")


if __name__ == '__main__':
    if os.geteuid() != 0:
        print bcolors.FAIL + "Script must run with 'sudo'" + bcolors.ENDC
        exit()
    if len(sys.argv) == 2 and sys.argv[1] == "-a":
        installAll()
    elif len(sys.argv) == 1:
        print bcolors.BOLD + bcolors.HEADER + "\n***** ONE INSTALLER (An Automated Package Installer) *****" + bcolors.ENDC + "\nChoose packages to install"
        try:
            input = raw_input(
                "{:>12} {:>20} {:>25}\n{:>18} {:>16} {:>31}\n{:>20} {:>11} {:>37}\n{:>13} {:>26} {:>21}\n{:>10} {:>29} {:>11}\n>" \
                .format("1. Eclipse(Neon)", "2. Docker", "3. Atom Editor",
                        "4. Wireshark 2.2.2", "5. JDK8", "6. Grub Customizer",
                        "7. 'Changer' init Script", "8. Pinta", "9. Short Cut Video Editor",
                        "10. Youtube-dll", "11. Onion Share", "12. TOR Browser",
                        "13. Miscellaneous", "14. Update & Upgrade", "15. Do All"))
        except:
            print "\n"
            exit()
        if input.strip() == "1":
            installEclipse()
            execuiteCommand("notify-send 'One Installer' 'Eclipse Installation Sucess!'")
        elif input.strip() == "2":
            installDocker()
            execuiteCommand("notify-send 'One Installer' 'Docker Installation Sucess!'")
        elif input.strip() == "3":
            installAtom()
            execuiteCommand("notify-send 'One Installer' 'Atom Editor Installation Sucess!'")
        elif input.strip() == "4":
            installWireshark()
            execuiteCommand("notify-send 'One Installer' 'Wireshark Installation Sucess!'")
        elif input.strip() == "5":
            installJDK()
            execuiteCommand("notify-send 'One Installer' 'Grub Customizer Installation Sucess!'")
        elif input.strip() == "6":
            installGrubCustomizer()
            execuiteCommand("notify-send 'One Installer' 'Grub Customizer Installation Sucess!'")
        elif input.strip() == "7":
            install_changer()
            execuiteCommand("notify-send 'One Installer' 'Changer init script Installation Sucess!'")
        elif input.strip() == "8":
            installPinta()
            execuiteCommand("notify-send 'One Installer' 'Pinta Installation Sucess!'")
        elif input.strip() == "9":
            execuiteCommand("sudo apt install snapd -y")
            execuiteCommand("notify-send 'One Installer' 'Short Cut Installation Sucess!'")
        elif input.strip() == "10":
            install_Youtube_Downloader()
        elif input.strip() == "11":
            install_onionShare()
            execuiteCommand("notify-send 'One Installer' 'Onion Share Installation Sucess!'")
        elif input.strip() == "12":
            install_Tor_Browser()
            execuiteCommand("notify-send 'One Installer' 'TOR Installation Sucess!'")
        elif input.strip() == "13":
            installPkgs()
        elif input.strip() == "14":
            execuiteCommand()
            execuiteCommand("sudo apt-get install upgrade -y")
        elif input.strip() == "15":
            installAll()

    else:
        print bcolors.BOLD + bcolors.OKGREEN + "\nUsage:   sudo python oneInstaller.py [-a]\n" + bcolors.ENDC
        print bcolors.BOLD + bcolors.OKGREEN + "".ljust(2, " ") + "-a".ljust(10,
                                                                             " ") + "Installs all packages\n" + bcolors.ENDC

