# DNSサーバ
自宅内の検証用環境内で名前解決するためのDNSサーバを構築した。

## 参考
- [内部向けDNSサーバの構築](https://mako-note.com/ja/dns/)
- [NSDの設定を(できるだけ最低限に)設定してみた。](https://qiita.com/higasa_JJ/items/878611ec347efd2c333a)
- [BIND : ゾーンファイルの設定](https://www.server-world.info/query?os=Debian_12&p=dns&f=3)

## 環境
今回は、インターネット接続可能な Home-net (`192.168.10.0/24`) と、外部接続不可の Lab-net (`192.168.50.0/24`) に対する名前解決を行う。DNSサーバのIPアドレスは、`192.168.10.2` および `192.168.50.2` とする。


![](./01_env.drawio.png)

なお、検証用環境のストレージ用 NAS は名前解決したFQDNで参照しているため、DNSの仮想マシンのストレージは NAS ではなくローカルに置いている。

## 方法
nsd をインストールし、設定する。

### インストール
```
# apt install nsd
```

### 設定
#### 設定ファイルの更新
`/etc/nsd/nsd.conf` を以下のように設定

```
# NSD configuration file for Debian.
#
# See the nsd.conf(5) man page.
#
# See /usr/share/doc/nsd/examples/nsd.conf for a commented
# reference config file.

server:
        # log only to syslog.
        #log-only-syslog: yes
        #ip-address: 192.168.1.2
        do-ip4: yes
        do-ip6: no
        port: 53
        zonesdir: "/etc/nsd/zone"
        hide-version: yes
        identity: "Home network authoritative DNS"

remote-control:
        control-enable: no

zone:
        name: "pve.home"
        zonefile: "pve.home.zone"

zone:
        name: "10.168.192.in-addr.arpa"
        zonefile: "pve.home.rev"

zone:
        name: "pve.lab"
        zonefile: "pve.lab.zone"

zone:
        name: "50.168.192.in-addr.arpa"
        zonefile: "pve.lab.rev"

# The following line includes additional configuration files from the
# /etc/nsd/nsd.conf.d directory.

include: "/etc/nsd/nsd.conf.d/*.conf"
```

#### ゾーンファイルの作成
`/etc/nsd/zone` 以下にゾーン設定用ファイルを作成。今回は、以下4つのファイルを作成。

- Home-net用
  - `pve.home.zone`
  - `pve.home.rev`
- Lab-net用
  - `pve.lab.zone`
  - `pve.lab.rev`

`pve.home.zone` の例：

```
$ORIGIN pve.home.
$TTL 86400 ; default time-to-live
@       IN      SOA     dns.pve.home. root.pve.home. (
        2024010501 ; Serial
        3600    ; Refresh
        1800    ; Retry
        604800  ; Expire
        86400   ; Minimum
)
        IN      NS      dns.pve.home.
        IN      A       192.168.10.2

dns     IN      A       192.168.10.2
ldap    IN      A       192.168.10.3
...
```

`pve.home.rev` の例：

```
$TTL 86400
@       IN      SOA     dns.pve.home. root.pve.home. (
        2024010501      ; Serial
        3600            ; Refresh
        1800            ; Retry
        604800          ; Expire
        86400           ; Minimum TTL
)

        IN      NS      dns.pve.home.

2       IN      PTR     dns.pve.home.
3       IN      PTR     ldap.pve.home.
...
```

ファイルを更新するたびに、`nsd` を restart

```
# systemctl restart nsd
```

### 動作確認
優先DNSに `192.168.10.2` を設定し、代替DNSに `192.168.10.1` (ルータのIPアドレス) を設定する。

```
> nslookup ldap.pve.home
サーバー:  dns.pve.home
Address:  192.168.10.2

名前:    ldap.pve.home
Address:  192.168.10.3
```

## バックアップ設定
`/etc/nsd` 以下を NFS 共有した NAS 上の共有フォルダに定期的にバックアップする。root ユーザの `crontab -e` で末尾に以下を追加。


```
0 5 * * * rsync -ahv /etc/nsd /mnt/Mars/10_server/16_dns
```

---

[Application](../README.md)
