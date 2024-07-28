# Proxmox クラスタの設定

## クラスタの作成・参加
### 参考
[![](https://img.youtube.com/vi/rMKwEOL2HSA/0.jpg)](https://www.youtube.com/watch?v=rMKwEOL2HSA)

### 手順
1. (クラスタを作成する場合) Datacenter > Cluster > Create Cluster でクラスタを作成
   - Cluster Name と Cluster Network を設定
2. 作成したクラスタの Join Information をコピー
3. (クラスタに参加したい場合) クラスタに参加したいノードで Datacenter > Cluster > Join Cluster からクラスタに参加
   - Information にコピーした情報をペースト。クラスタを作成したノードのアドレス、パスワードを入力
   - エラーが出る場合は、VMの電源を落とす、VMの設定ファイル `/etc/pve/nodes/[node name]/qemu-server/*.conf` を削除 (移動しておいて後で戻す)

## クラスタ構築後のIPアドレスの変更
### 参考
[![](https://img.youtube.com/vi/IPUspSZ9geM/0.jpg)](https://www.youtube.com/watch?v=IPUspSZ9geM)

- [How To: Change the IP Address of a Proxmox Clustered Node](https://bookstack.dismyserver.net/books/documentation/page/how-to-change-the-ip-address-of-a-proxmox-clustered-node)

### 手順
クラスタに属するすべてのノードで以下を実施。

1. Proxmox のノードに SSH 接続
2. `/etc/network/interfaces` で変更したいIPアドレスを書き換える
3. クラスタ関連のサービスを停止 (これらのサービスを停止させると `/etc/pve` のマウントが解除されて中身が空になる)
   ```
   # systemctl stop pve-cluster
   # systemctl stop corosync
   ```
4. ファイルシステムをマウントする
   ```
   # pmxcfs -l
   ```
5. `/etc/pve/corosync.conf` でIPアドレスを書き換える
6. 再起動

上手くいかなければ、`/etc/hosts` のアドレスも書き換える。

---

[Usage](../README.md)
