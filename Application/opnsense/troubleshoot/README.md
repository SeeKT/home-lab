# OPNsense のトラブルシューティング
OPNsense まわりのトラブルシューティングをまとめる。

- [OPNsense のトラブルシューティング](#opnsense-のトラブルシューティング)
  - [WAN 側から入れない](#wan-側から入れない)
  - [ファイアウォールのルールのロードに失敗する](#ファイアウォールのルールのロードに失敗する)


## WAN 側から入れない
デフォルト設定ではWAN側から入れない。これは、Default Deny となっているため。以下ルールを追加するとWAN側からも入れる。

- Action: Pass
- Interface: WAN
- Direction: in
- TCP/IP Version: IPv4
- Protocol: TCP
- Source: WAN net
- Destination: WAN address
- Destination port range: from HTTPS to HTTPS
- Gateway: default

## ファイアウォールのルールのロードに失敗する
しばらく使っていると以下のエラーが出され、ファイアウォールのルールのロードに失敗した。

```
Date    Severity    Process Line
2024-07-02T19:59:51	Error	firewall	There were error(s) loading the rules: /tmp/rules.debug:24: cannot load "/usr/local/etc/bogonsv6": Invalid argument - The line in question reads [24]: table <bogonsv6> persist file "/usr/local/etc/bogonsv6"	
2024-07-02T19:59:51	Error	firewall	/usr/local/etc/rc.bootup: The command '/sbin/pfctl -f /tmp/rules.debug.old' returned exit code '1', the output was '/tmp/rules.debug.old:24: cannot load "/usr/local/etc/bogonsv6": Invalid argument pfctl: Syntax error in config file: pf rules not loaded'	
2024-07-02T19:59:48	Error	firewall	There were error(s) loading the rules: /tmp/rules.debug:24: cannot load "/usr/local/etc/bogonsv6": Invalid argument - The line in question reads [24]: table <bogonsv6> persist file "/usr/local/etc/bogonsv6"	
2024-07-02T19:59:48	Error	firewall	/usr/local/etc/rc.bootup: The command '/sbin/pfctl -f /tmp/rules.debug.old' returned exit code '1', the output was '/tmp/rules.debug.old:24: cannot load "/usr/local/etc/bogonsv6": Invalid argument pfctl: Syntax error in config file: pf rules not loaded'	
2024-07-02T19:59:47	Error	firewall	There were error(s) loading the rules: /tmp/rules.debug:24: cannot load "/usr/local/etc/bogonsv6": Invalid argument - The line in question reads [24]: table <bogonsv6> persist file "/usr/local/etc/bogonsv6"	
2024-07-02T19:59:47	Error	firewall	/usr/local/etc/rc.bootup: The command '/sbin/pfctl -f /tmp/rules.debug.old' returned exit code '1', the output was 'pfctl: /tmp/rules.debug.old: No such file or directory pfctl: cannot open the main config file!: No such file or directory pfctl: Syntax error in config file: pf rules not loaded'
```

`bogonsv6` をロードしようとしてエラーが出ているようである。IPv6 は使わないので、一旦 IPv6 を許可しないように設定する。

Firewall > Settings > Advanced で、Allow IPv6 のチェックを外す。

結果：エラーが消え、問題なくロードされた


---

[OPNsense](../README.md)
