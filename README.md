# Init My Ubuntu
[IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) setup to install necessary packages and configure my Ubuntu(Or any Debian distro).

<img src="https://user-images.githubusercontent.com/8393701/248329468-ed036c98-08e7-4ee6-99ef-d5cef2e48a95.png" alt="Ubuntu" width="300"/>

* All packages listed in [`vars.yml`](./vars.yml)
* Tags to provide to ansible playbook
  * No Tag -  Runs cli tasks to install cli related tools
  * `desktop` - Runs `desktop` and `cli` tasks to install desktop related apps

## Run
```
curl https://raw.githubusercontent.com/veerendra2/init-my-ubuntu/master/run.sh | bash
```

## Other Repos
| Repo | OS |
| ---- | ---- |
| https://github.com/veerendra2/init-my-windows | <img src="https://user-images.githubusercontent.com/8393701/248329539-0b792b81-2d32-4ef9-b92e-0350ad472d61.png" alt="Windows" width="25"/> |
| https://github.com/veerendra2/init-my-mac | <img src="https://user-images.githubusercontent.com/8393701/248331160-ae1cd8f6-7c4b-483b-9799-6b44ed3f30f2.png" alt="Mac" width="25"/> |
