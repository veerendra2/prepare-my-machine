![GitHub forks](https://img.shields.io/github/forks/veerendra2/init-my-laptop?style=plastic)
![GitHub Repo stars](https://img.shields.io/github/stars/veerendra2/init-my-laptop?style=plastic)
# Init My Ubuntu
[IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) setup to install necessary packages and configure my Ubuntu(Or any Linux distro).

* Tested on `Ubuntu 22.04 LTS`
* All packages listed in [`vars.yml`](./vars.yml)
* Tags to provide to ansible playbook
  * `cli` Runs cli tasks to install cli related tools
  * `desktop` Run desktop tasks to install desktop related apps
  * `all` Runs `cli` + `desktop` tasks


## Run
```
curl https://raw.githubusercontent.com/veerendra2/ubuntu-dev/master/run.sh | bash -s all
```
Or
```
$ git clone https://github.com/veerendra2/ubuntu-dev.git
$ cd ubuntu-dev
$ pip3 install ansible
$ ansible-playbook main.yml -tags=all # all|cli|desktop
```
