# 最初にやること
Proxmox を構築して最初にやることをまとめる。Proxmox は v8.2 を想定している。

- [最初にやること](#最初にやること)
  - [やることリスト](#やることリスト)
    - [リポジトリの更新](#リポジトリの更新)
    - [クラスタ構築 (追加)](#クラスタ構築-追加)


## やることリスト
- [ ] `apt` のリポジトリの更新
- [ ] クラスタ構築 (追加)

### リポジトリの更新
サブスクリプションなしで利用する場合は、利用可能なリポジトリを追加して商用のリポジトリをコメントアウトする

- `/etc/apt/sources.list` に追加
    ```
    deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
    ```
- `/etc/apt/sources.list.d/pve-enterprise.list` の中身をコメントアウト
    ```
    #deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise
    ```
- `/etc/apt/sources.list.d/ceph.list` の中身をコメントアウト
    ```
    #deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise
    ```

### クラスタ構築 (追加)
[Proxmox クラスタの設定](../cluster/README.md) に記載。

---

[Usage](../README.md)
