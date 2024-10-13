# Suricata のインストール (apt)
Ubuntu に Suricata を apt でインストールする。

## Installation
インストール用スクリプトを作成した ([install_suricata.sh](../install_suricata.sh))。

```
$ sudo apt install software-properties-common
$ sudo add-apt-repository -E ppa:oisf/suricata-stable
$ sudo apt-get update
$ sudo apt-get install suricata
```

## Settings
### Rules
```
$ wget https://rules.emergingthreats.net/open/suricata-7.0.3/emerging.rules.tar.gz
$ tar -zxvf emerging.rules.tar.gz
$ sudo cp -r rules/ /etc/suricata/rules
```

`/etc/suricata` 以下に `update.yaml`, `enable.conf`, `disble.conf`, `modify.conf` を作成。

```
$ sudo suricata-update
$ sudo suricata -T
```

### Configuration
2つのファイルを編集する。

- `/etc/default/suricata`
  - suricata を実行するときにデフォルトで読み込まれる設定
- `/etc/suricata/suricata.yaml`
  - `HOME_NET` や `EXTERNAL_NET` の設定

#### `/etc/default/suricata`
```
RUN_AS_USER=#{USERNAME}
LISTENMODE=af-packet
IFACE=#{IF}
```

#### `/etc/suricata/suricata.yaml`

```yaml
vars:
    address-groups:
        HOME_NET: "[#{IP},#{IP},...]"
        EXTERNAL_NET: "!$HOME_NET"
...
default-log-dir: #{LOGDIR}
...
pcap:
    - interface: #{IF}
```


## Run
```
$ sudo suricata -c /etc/suricata/suricata.yaml -i #{IF} -v
```

---

[Suricata](../README.md)
