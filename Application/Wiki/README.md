# Wikiサーバ
[Gollum](https://github.com/gollum/gollum) を使った Wiki サーバ構築方法について。

## インストール
### 依存関係のインストール
```
# apt update
# apt install -y libicu-dev cmake libssh-dev libssl2-1-dev pkg-config make zlib1g-devbuild-essential git asciidoc
```

### Ruby のインストール
```
# apt -y install ruby
# apt install -y ruby-full
# apt install -y rubygems
# gem install rubygems-update
# apt -y install ruby-dev libruby
```

### Gollum のインストール
```
# gem install therubyracer gollum org-ruby omnigollum github-markup omniauth-github github-markdown
```

## サーバの起動
Git と連携している。

### 初回起動時

```
$ mkdir wiki
$ cd wiki
$ git init
$ gollum
```

### 自動起動設定
`systemd` を使い、ホスト起動時に自動起動するように設定する。

#### 参考
- [Ubuntuで起動時に自動でShellScriptを実行する方法](https://qiita.com/MAI_onishi/items/74edc40a667dd2dc633e)

#### 手順
1. 起動スクリプト作成 > `/home/debian/start.sh` を作成
    ```sh
    #!/bin/bash
    gollum /home/debian/wiki
    ```
2. service ファイル作成 > `/etc/systemd/system/gollum.service` を作成
   ```
   [Unit]
    Description=gollum wiki server
    After=network.target

    [Service]
    User=debian
    ExecStart=/home/debian/start.sh
    Restart=always
    type=simple

    [Install]
    WantedBy=multi-user.target
   ```
3. 自動起動設定
   ```
   # systemctl daemon-reload
   # systemctl enable gollum.service
   ```

## 定期バックアップ
`crontab` で毎日 NAS にバックアップをとるように設定する。


### 前提
起動時の自動マウント設定 (c.f. [NASの導入](../../Usage/NAS/README.md)) > `/etc/fstab` の末尾に以下が追加済

```
<NASのアドレス (FQDN)>:<共有フォルダのマウントパス>   /<NFSクライアントのマウントポイント>   nfs defaults    0   0
```

### 方法
```
# crontab -e
```

以下を追加し、`rsync` コマンドを使って `.git/` と `.redirects.gollum` 以外を NAS にバックアップするように設定

```
00 5 * * * rsync -ahv /home/debian/wiki /mnt/Mars/10_server/11_wiki --exclude '.git/' --exclude '.redirects.gollum'
```


---

[Application](../README.md)
