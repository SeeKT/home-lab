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


---

[Application](../README.md)
