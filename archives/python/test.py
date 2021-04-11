#!/usr/bin/env python
'''
@author: Veerendra Kakumanu
@summary: Installs  packages for Ubuntu 14
'''
import os
import getpass
import subprocess
import sys
import itertools
import logging
from logging.handlers import RotatingFileHandler
import argparse

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
LOG_LOCATION = 'one_installer.log'
MAX_SIZE_LOG = 20 #Mega Bytes
BACKUP_COUNT = 0
spin = itertools.cycle("|/-\\")
handler = RotatingFileHandler(LOG_LOCATION, mode='a', maxBytes=MAX_SIZE_LOG*1024*1024, backupCount=BACKUP_COUNT, encoding=None, delay=0)
log = logging.getLogger('one_installer')

ppa = {
    "atom": "ppa:webupd8team/atom -y",
    "wireshark": "ppa:wireshark-dev/stable -y",
    "pinta": "ppa:pinta-maintainers/pinta-stable -y",
    "onionShare": "ppa:micahflee/ppa -y",
    "dns-crypt": "add-apt-repository ppa:shevchuk/dnscrypt-proxy -y",
    "anoise": "ppa:costales/anoise -y"
}

custom_scripts_urls = {
    "httpserver": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/httpserver.py",
    "nettools": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/netTools.py",
    "ssid_list": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/ssid_list.py",
    "pastebin": "https://raw.githubusercontent.com/veerendra2/useless-scripts/master/tools/pastebin.py",
    "deauth": "https://raw.githubusercontent.com/veerendra2/wifi-deauth-attack/master/deauth.py"
}

repos_links = {
    "my-utils": "https://github.com/veerendra2/my-utils.git",
    "veerendra2.github.io": "https://github.com/veerendra2/veerendra2.github.io.git",
    "prometheus-k8s-monitoring": "https://github.com/veerendra2/prometheus-k8s-monitoring.git",
    "my-k8s-applications": "https://github.com/veerendra2/my-k8s-applications.git",
}

desktop_packages = [
    "atom", "pinta",
    "onionshare", "wireshark --force-yes",
    "dnscrypt-proxy"
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

python_packages = [
    "requests", "thefuck",
    "frida-tools", "beautifulsoup4",
    "ansible", "funmotd",
    "youtube_dl"
]

dependency_packages = [
    "apt-transport-https", "ca-certificates",
    "curl", "gnupg-agent",
    "software-properties-common",
    "git", "python-pip",
    "python3-pip"
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

'''

def log_it(level, message):
    log.setLevel(levels[level])
    log.addHandler(handler)
    handler.setLevel(levels[level])
    if level == "info":
        log.info(message)
    elif level == "critical":
        log.critical(message)


def execuiteCommand(msg, cmd, verbose=True, sudo=True):
    if sudo:
        cmd = "sudo "+cmd
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out = []
    if verbose:
        print "{}".format(msg).ljust(40, "."),
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


class pkg_install:
    def __init__(self):
        self.update()
        execuiteCommand("Upgrade", "apt-get upgrade -y")
        execuiteCommand("Installing Dependency Packages", "apt-get upgrade {} -y".format(" ".join(dependency_packages)))

    def update(self):
        ret_code = execuiteCommand("Update", "apt-get update")
        if ret_code == 1:
            print "[-] Failed to update"
            exit(1)

    def install_gen(self):
        print "\n**General Packages **"
        for pkg in general_packages:
            execuiteCommand("Installing {}".format(pkg), "apt-get install {} -y".format(pkg))

    def install_dev(self):
        print "\n** Dev Packages **"
        for pkg in dev_packages:
            execuiteCommand("Installing {}".format(pkg), "apt-get install {} -y".format(pkg))

    def install_pro(self):
        print "\n** Pro Packages **"
        for pkg in pro_packages:
            execuiteCommand("Installing {}".format(pkg), "apt-get install {} -y".format(pkg))

    def install_pip_pkgs(self):
        print "\n** Python PIP Packages **"
        for pkg in python_packages:
            execuiteCommand("Installing {}".format(pkg), "apt-get install {} -y".format(pkg))

    def install_desktop_app(self):
        print "\n** Desktop Apps **"
        for repo in ppa:
            execuiteCommand("Adding Repo {}".format(repo), "add-apt-repository {} -y".format(repo))
        self.update()
        for pkg in dev_packages:
            execuiteCommand("Installing {}".format(pkg), "apt-get install {} -y".format(pkg))

    def install_custom_scripts(self):
        print "\n** Custom Scripts **"
        for name, link in custom_scripts_urls.items():
            execuiteCommand("Downloading {}".format(name), "curl -qO /usr/local/bin/{} {}".format(name, link))
            execuiteCommand("", "chmod +x /usr/local/bin/{}".format(name), verbose=False, sudo=True)
        execuiteCommand("Downloading changer", "curl -qO /etc/init.d/changer https://git.io/Jey5v")
        execuiteCommand("", "chmod +x /etc/init.d/changer", verbose=False, sudo=True)
        execuiteCommand("", "update-rc.d changer defaults", verbose=False, sudo=True)

    def clone_repos(self):
        print "\n** Clone Repos **"
        projects_path = "/home/{}/projects".format(getpass.getuser())
        os.mkdir(projects_path)
        os.chdir(projects_path)
        for name, repos in repos_links.items():
            execuiteCommand("Cloning {}".format(name), "git clone {}".format(repos))
        os.chdir(base_path)

    def install_radare(self):
        os.chdir(tempfile.mkdtemp())
        execuiteCommand("\nCloning radare2", "git clone https://github.com/radareorg/radare2")
        os.chdir("./radare2")
        execuiteCommand("Build and install radare2", "sys/install.sh")
        os.chdir(base_path)

    def installDocker(self):
        execuiteCommand("\nInstalling Docker Dependencies", "apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common")
        execuiteCommand("Adding Docker GPG Keys", "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -")
        execuiteCommand("Adding PPA", "add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'")
        self.update()
        execuiteCommand("Installing Docker", "apt-get install docker-ce docker-ce-cli")

'''
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





def setMotd():
    execuiteCommand("wget -q -O /etc/motd https://goo.gl/tCpJrR")
    with open("/etc/motd", "r") as f:
        lines = f.readlines()
    lines[0] = "\n>> {} MACHINE\n".format(hostname.upper())
    with open("/etc/motd", "w") as f:
        f.writelines(lines)


def install_changer():
    execuiteCommand()
    execuiteCommand(commands["macchanger"])
    execuiteCommand("wget -q -O /etc/init.d/changer https://goo.gl/tRfoJo")
    execuiteCommand("sudo chmod +x /etc/init.d/changer")
    execuiteCommand("sudo update-rc.d changer defaults")

'''
if __name__ == '__main__':
    obj = pkg_install()
    obj.install_dev()
    obj.install_gen()
    obj.install_pro()
    obj.install_pip_pkgs()
    obj.install_desktop_app()
    obj.install_custom_scripts()
    obj.installDocker()
