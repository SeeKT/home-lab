# GitLabサーバ
Docker Compose を使って自宅内検証用環境に GitLab を導入する。

## 参考
- [Install GitLab by using Docker](https://docs.gitlab.com/ee/install/docker.html)
- [GitLab をインストールしよう! (Docker Image)](https://qiita.com/masakura/items/e29f1dd4794bcaf066ce)
- [How to Install GitLab CE with Docker on Debian 12](https://www.howtoforge.com/how-to-install-gitlab-with-docker-on-debian-12/)
- [Integrate LDAP with GitLab](https://docs.gitlab.com/ee/administration/auth/ldap/?tab=Docker)


## 前提
Docker がインストール済とする。また、GitLab のホームディレクトリはマウントした NAS 上にあるとする (マウントポイントは `/mnt/Mars/10_server/14_gitlab`)。

## インストール
`/root/docker/` 以下を作業ディレクトリとし、`docker-compose.yml` ファイルを作成する。なお、`LDAP_PASSWORD` や `GITLAB_HOME` は `docker-compose.yml` と同階層に `.env` ファイルを作成し、その変数を登録する。

この `docker-compose.yml` では、LDAP の設定もしている。

以下コマンドで起動する。

```
# docker compose -f <path of docker-compose.yml> up -d
```

ログの確認は以下コマンドで実施。

```
# docker logs <container name> -f
```

コンテナの状態は以下コマンドで確認可能。

```
# docker ps
```

ここで、コンテナの状態が `Up (healthy)` となっているとブラウザから GitLab にログインできる。

初期パスワードは、`$GITLAB_HOME/config/initial_root_password` に記載されている。root/初期パスワードでログイン可能。

## トラブルシューティング
コンテナを起動しようとしたところ、以下エラーが出力された。

```
Attaching to gitlab-pvehome
gitlab-pvehome  | Thank you for using GitLab Docker Image!
gitlab-pvehome  | Current version: gitlab-ee=17.0.0-ee.0
gitlab-pvehome  |
gitlab-pvehome  | Configure GitLab for your system by editing /etc/gitlab/gitlab.rb file
gitlab-pvehome  | And restart this container to reload settings.
gitlab-pvehome  | To do it use docker exec:
gitlab-pvehome  |
gitlab-pvehome  |   docker exec -it gitlab editor /etc/gitlab/gitlab.rb
gitlab-pvehome  |   docker restart gitlab
gitlab-pvehome  |
gitlab-pvehome  | For a comprehensive list of configuration options please see the Omnibus GitLab readme
gitlab-pvehome  | https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md
gitlab-pvehome  |
gitlab-pvehome  | If this container fails to start due to permission problems try to fix it by executing:
gitlab-pvehome  |
gitlab-pvehome  |   docker exec -it gitlab update-permissions
gitlab-pvehome  |   docker restart gitlab
gitlab-pvehome  |
gitlab-pvehome  | Cleaning stale PIDs & sockets
gitlab-pvehome  | It seems you are upgrading from 16.9.2-ee to 17.0.0.
gitlab-pvehome  | It is required to upgrade to the latest 16.11.x version first before proceeding.
gitlab-pvehome  | Please follow the upgrade documentation at https://docs.gitlab.com/ee/update/index.html#upgrading-to-a-new-major-version
gitlab-pvehome exited with code 0
```

エラーログを見ると、GitLab を `16.9.2-ee` から `17.0.0` にアップグレードしたことが原因と考えられる (先に `16.11.x` にアップグレードする必要がある)。

直接的な原因は、`docker-compose.yml` ファイルで `gitlab/gitlab-ee:latest` を指定していたことと考えられるので、タグを `16.9.8-ee.0` にして再度検証したところ、問題なく起動した。

## バックアップ設定
これまで GitLab サーバが定期的に動かなくなる事象が発生していたので、`crontab` を使って毎日バックアップをとるようにする。Root で `crontab -e` を実行して、`rsync` コマンドによるバックアップを毎日行うように設定する。

```
00 5 * * * rsync -ahv /mnt/Mars/10_server/14_gitlab /mnt/Mars/10_server/15_gitlab_backup
```

---

[Application](../README.md)
