# auditd

## 参考
- [auditdでLinuxのファイル改竄検知を行う](https://qiita.com/minamijoyo/items/0d77959a869e458d850a)

## インストール
```
# apt-get update
# apt-get install auditd
```

## 設定
- 設定ファイル: `/etc/audit/auditd.conf`
- ルール定義: `/etc/audit/audit.rules`
- ログ (デフォルト): `/var/log/audit/audit.log`
  - Syslog などにも出せる

---

[Application](../README.md)
