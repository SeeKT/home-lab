# 作業ログ
ここでは、GitLab サーバを Debian Desktop から Ubuntu Server に移植する作業ログをまとめる。

- [作業ログ](#作業ログ)
  - [Ubuntu Server のインストール](#ubuntu-server-のインストール)
    - [IP アドレスの固定](#ip-アドレスの固定)
    - [SSH の設定](#ssh-の設定)
    - [NFS の設定](#nfs-の設定)
    - [Docker の設定](#docker-の設定)
  - [GitLab の立ち上げ](#gitlab-の立ち上げ)


## Ubuntu Server のインストール
今回は、Ubuntu Server 24.04.1 LTS をインストールする。特に、以下パッケージはインストールしておく。

- ssh
- nfs-common
- docker

### IP アドレスの固定
今回は、`192.168.10.60/24` に固定する。

`/etc/netplan/99-settings.yaml` を以下のように作成する。

```yaml
network:
    ethernets:
        ens18:
            dhcp4: false
            addresses:
            - 192.168.10.60/24
            nameservers:
                addresses: [192.168.10.2, 192.168.10.1]
            routes:
            - to: default
              via: 192.168.10.1
    version: 2
```

また、`root` で権限を `600` として、`50-cloud-init.yaml` を `50-cloud-init.yaml.disabled` に名前を変更する。

```
$ sudo netplan apply
```

で設定変更し、再起動する。

### SSH の設定
```
$ sudo apt install ssh
```

SSH はポート番号を 22 から 10022 に変更する。

`/etc/ssh/sshd_config` で、

```
#Port 22
Port 10022
```

のように、ポートを変更し、SSH を再起動する。

```
$ sudo systemctl restart ssh
```

### NFS の設定
```
$ sudo apt install nfs-common
```

起動時に NAS の NFS をマウントするように設定する。

`/etc/fstab` の末尾に以下を追加後、再起動。

```
mercury.pve.home:/volume2/Mars  /mnt/Mars   nfs defaults    0   0
```

### Docker の設定
[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) に記載の通りにインストール。

## GitLab の立ち上げ
```
$ docker compose -f <path of docker-compose.yml> up -d
```

エラーが出たが放置したら動いたので一旦このまま稼働させる。

---

[GitLab](../README.md)
