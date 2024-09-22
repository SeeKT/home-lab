# メールサーバ
LAN 内で使えるメールサーバを構築する。

- [メールサーバ](#メールサーバ)
  - [参考](#参考)
  - [設定](#設定)
    - [Postfix インストール](#postfix-インストール)
    - [Dovecot インストール](#dovecot-インストール)
    - [メールユーザアカウント登録](#メールユーザアカウント登録)


## 参考
- [Mail サーバー : Postfix インストール](https://www.server-world.info/query?os=Debian_12&p=mail)
- [Mail サーバー : Dovecot インストール](https://www.server-world.info/query?os=Debian_12&p=mail&f=2)

## 設定
### Postfix インストール
```
# apt -y install postfix sasl2-bin
```

```
# cp /usr/share/postfix/main.cf.dist /etc/postfix/main.cf
# nano /etc/postfix/main.cf
```

設定ファイルを [Mail サーバー : Postfix インストール](https://www.server-world.info/query?os=Debian_12&p=mail&f=1) に記載のように編集。

```
# systemctl restart postfix
```

### Dovecot インストール
```
# apt -y install dovecot-core dovecot-pop3d dovecot-imapd
```

`/etc/dovecot/dovecot.conf`, `/etc/dovecot/conf.d/10-auth.conf`, `/etc/dovecot/conf.d/10-mail.conf`, `/etc/dovecot/conf.d/10-master.conf` を [Mail サーバー : Dovecot インストール](https://www.server-world.info/query?os=Debian_12&p=mail&f=2) に記載のように編集。

### メールユーザアカウント登録
```
# apt -y install mailutils
# echo 'export MAIL=$HOME/Maildir/' >> /etc/profile.d/mail.sh
# source /etc/profile.d/mail.sh
```


---

[Application](../README.md)
