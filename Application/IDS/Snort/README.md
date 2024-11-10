# Snort

## 参考
- [Snort 3 Rule Writing Guide](https://docs.snort.org/start/)
- [Snort3（設定）](https://www.kaisekisya.net/linux/snort3/three.html)

## Installation
Snort インストール用のシェルスクリプトを作成した ([install_snort.sh](install_snort.sh))。


## Settings
### Rules
ここでは Community Rules を活用する。

```
$ wget https://www.snort.org/downloads/community/snort3-community-rules.tar.gz
$ tar -zxvf snort3-community-rules.tar.gz
$ sudo cp snort3-community-rules/snort3-community.rules #{SNORTDIR}/etc/snort
```

### Configuration
`#{SNORTDIR}/etc/snort/snort.lua` を編集する。

- HOME/EXTERNAL
- Rules
- Outputs

```lua
HOME_NET = '[[#{IP},#{IP},...]]'
EXTERNAL_NET = '[[!$HOME_NET]]'
```

### Rules
`snort.lua` と同階層に配置した `snort3-community.rules` を読み込む。

```lua
ips = 
{
    include = 'snort3-community.rules',
    variables = default_variables
}
```

### Outputs
以下のように設定すると、`$(pwd)/alert_*.txt` としてアラートが出力される。

```
alert_csv = 
{
    file=true,
}

alert_fast =
{
    file=true,
}

alert_json =
{
    file=true,
}
```

## Run
```
$ sudo #{SNORTDIR}/bin/snort -c #{SNORTDIR}/etc/snort/snort.lua -i #{IF} -l #{LOGDIR}
```

---

[Application](../README.md)
