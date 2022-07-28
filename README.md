![GitHub forks](https://img.shields.io/github/forks/veerendra2/init-my-laptop?style=plastic) 
![GitHub Repo stars](https://img.shields.io/github/stars/veerendra2/init-my-laptop?style=plastic)
# Init My Ubuntu Laptop
An ansible playbook to prepare my ubuntu laptop

* Tested on `Ubuntu 22.04 LTS`
* All packages listed in [`vars.yml`](./vars.yml)
* Tags to provide to ansible playbook
  * `cli` Runs cli tasks to install cli related tools
  * `desktop` Run desktop tasks to install desktop related apps 
  * `all` Runs `cli` + `desktop` tasks


## Run
```
curl https://raw.githubusercontent.com/veerendra2/init-my-laptop/master/run.sh | bash -s all
```
Or
```
$ git clone https://github.com/veerendra2/init-my-laptop.git
$ cd init-my-laptop
$ pip3 install ansible
$ ansible-playbook main.yml -tags=all # all|cli|desktop
```