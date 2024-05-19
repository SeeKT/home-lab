# Docker の導入
Debian に Docker を導入する。

## 参考
- [Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)

## インストール
以下シェルスクリプトを作成し、実行権限を与えて実行する。

```sh
#!/bin/bash
# Set up Docker's apt repository
apt-get update
apt-get -y install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install the Docker packages
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# auto start
systemctl unmask docker.service
systemctl enable docker
systemctl is-enabled docker

# run as user
usermod -aG docker debian
gpasswd -a debian docker
```

---

[Application](../README.md)
