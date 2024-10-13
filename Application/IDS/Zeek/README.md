# Zeek

## 参考
- [Zeek Documentation](https://docs.zeek.org/en/v7.0.3/)
- [Spicy — Generating Robust Parsers for Protocols & File Formats](https://docs.zeek.org/projects/spicy/en/latest/index.html)

## Installation
Zeek と Spicy をインストールするためのスクリプトを作成した ([install_zeek.sh](install_zeek.sh))。

## Configuration
### Node
`/opt/zeek/etc/node.cfg`

```
[zeek]
type=standalone
host=localhost
interface=#{IF}
```

### Local Network
`/opt/zeek/etc/networks.cfg`

```
#{ADDRESS}  #{DESCRIPTION}
```

## `zeekctl`
`/opt/zeek/etc/zeekctl.cfg` でログの出力先等を変更する。

```
LogDir = /mnt/Mars/10_server/12_IDS/zeek/logs
SpoolDir = /mnt/Mars/10_server/12_ids/zeek/spool
BrokerDBDir = /mnt/Mars/10_server/12_ids/zeek/spool/brokerstore
FileExtractDir = /mnt/Mars/10_server/12_ids/zeek/spool/extract_files
```

なお、出力先作成後に権限をもともとのログ出力先のディレクトリ (`/opt/zeek/logs`) 等に合わせておく。

```
$ sudo mkdir -p /mnt/Mars/10_server/12_ids/zeek/logs
$ sudo mkdir -p /mnt/Mars/10_server/12_ids/zeek/spool
$ sudo cp -r /opt/zeek/spool/* /mnt/Mars/10_server/12_ids/zeek/spool
$ sudo chown root:zeek /mnt/Mars/10_server/12_ids/zeek/logs
$ sudo chown root:zeek /mnt/Mars/10_server/12_ids/zeek/spool
$ sudo chmod 2770 /mnt/Mars/10_server/12_ids/zeek/logs
$ sudo chmod 2770 /mnt/Mars/10_server/12_ids/zeek/spool
```

```
$ sudo /opt/zeek/bin/zeekctl
> install
> deploy
```

---

[Application](../README.md)
