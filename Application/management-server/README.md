# 管理用サーバ (物理) の構成
現在複数の VM として構成している管理用サーバを1つのサーバ (物理) にまとめる。


- [管理用サーバ (物理) の構成](#管理用サーバ-物理-の構成)
  - [参考情報](#参考情報)
  - [概要](#概要)
  - [リンク](#リンク)
  - [新サーバ構築の方針](#新サーバ構築の方針)
  - [設定のバックアップ](#設定のバックアップ)
    - [DNSサーバ](#dnsサーバ)
    - [メールサーバ](#メールサーバ)
    - [LDAPサーバ](#ldapサーバ)
  - [インストール・設定](#インストール設定)
    - [DNSサーバ](#dnsサーバ-1)
    - [メールサーバ](#メールサーバ-1)
    - [LDAP](#ldap)

## 参考情報
- DNSサーバ関連
  - [systemd-resolvedの特徴と使い方紹介](https://endy-tech.hatenablog.jp/entry/systemd-resolved-basics)
  - [メモ：unboundを入れたらsystemd-resolvedをちゃんと無効化しないといけない件](https://science-as-a-candle-in-the-dark.hatenablog.com/entry/2022/07/15/201303)
  - [UnboundとNSDを使ったDNSサーバー構築](https://blog.nomott.com/dns-unbound-nsd-keepalived/)

## 概要
現状、Proxmox 仮想サーバ内で自身を管理するためのサーバ (VM) を構築している。この構成には以下課題がある。

- DNS サーバが仮想サーバ内にあるので、仮想サーバを起動して当該VMを起動しないと名前解決ができない
  - 現状、Proxmox 側でもストレージサーバを FQDN で参照しているので、名前解決できないとストレージを認識できない
- GitLab サーバのために必要なメールサーバや LDAP サーバを別々のVMとして構築しているが、その分のオーバヘッドが発生している

そこで、Proxmox 管理外の物理機器として DNS サーバ、メールサーバ、LDAP サーバの機能を持つマシンを構築する。

## リンク
- [DNSサーバ](../DNS/)
- [メールサーバ](../mail/)
- [LDAPサーバ](../LDAP/)

## 新サーバ構築の方針
- OS は Ubuntu 24.04.2 LTS
  - デスクトップ環境は不要、長期サポートが望ましい
- DNS 名は `management.pve.home` にする
  - 複数の用途を1つにまとめるという意味も込めて
- IP アドレスは `192.168.10.2` および `192.168.50.2` にする
  - これまでの LDAP Server の IP アドレスを引き継ぐ
- 設定もこれまでの各サーバの設定を引き継ぐ

## 設定のバックアップ
NAS (NFS共有) に各 VM の各アプリケーションのデータをバックアップする。

### DNSサーバ
```
# rsync -ahv /etc/nsd /mnt/Mars/10_server/16_management/dns/nsd
```

### メールサーバ
```
# rsync -ahv /etc/postfix /mnt/Mars/10_server/16_management/mail/postfix
# rsync -ahv /etc/dovecot /mnt/Mars/10_server/16_management/mail/dovecot
```

### LDAPサーバ
```
# rsync -ahv /root/ldap /mnt/Mars/10_server/16_management/ldap
```

## インストール・設定
### DNSサーバ
[DNSサーバ](../DNS/) に記載の nsd の設定をしたが、以下エラーが出た。

```
error: can't bind udp socket 0.0.0.0@53: Address already in use
error: server initialization failed, nsd could not be started
```

`systemd-resolved` が 53/udp を使っていることが原因と予想される。そこで、`systemd-resolved` を無効化する (この設定が問題ないかは要検討)。

```
# systemctl stop systemd-resolved
# systemctl disable systemd-resolved
```

さらに、`/etc/resolv.conf` に DNS サーバのアドレスを追加する。

```
nameserver 192.168.10.2
nameserver 192.168.10.1
nameserver 192.168.50.2
```

この状態で、`nsd` を開始する。

```
# systemctl restart nsd
```

名前解決に成功した。

```
PS C:\Users\kosuk> nslookup management.pve.home
サーバー:  management.pve.home
Address:  192.168.10.2

名前:    management.pve.home
Address:  192.168.10.2
```

バックアップ設定を行う。`crontab -e` で末尾に以下を追加

```
0 5 * * * rsync -ahv /etc/nsd /mnt/Mars/10_server/16_management/dns/nsd
```

また、ログ出力の設定をする。`/etc/rsyslog.d/41-dns-nsd.conf` を作成し、以下のように編集する。

```
:syslogtag, contains, "nsd" -/var/log/nsd.log
& stop
```

### メールサーバ
[メールサーバ](../mail/) に記載の通りにインストール後に、バックアップした設定ファイルをコピー。ホスト名は `management.pve.home` に変更。

```
# cp /mnt/Mars/10_server/16_management/mail/postfix/main.cf /etc/postfix
# cp /mnt/Mars/10_server/16_management/mail/dovecot/conf.d/{10-auth,10-mail,10-master}.conf /etc/dovecot/conf.d/
```

サービスを再起動。

```
# systemctl restart postfix
# systemctl restart dovecot
```

また、メールのユーザアカウントも追加しておく。

### LDAP
[LDAPサーバ](../LDAP/) と同じ設定をする。LDAP アカウントを使っているサービス (GitLab/Proxmox) で設定変更する。

問題なく設定できた。

---

[Application](../README.md)
