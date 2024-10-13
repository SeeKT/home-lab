# VMの登録解除
VM のストレージ自体は残したまま、Web UI に表示されないようにする方法について。

## 参考
[![](https://img.youtube.com/vi/rMKwEOL2HSA/0.jpg)](https://www.youtube.com/watch?v=rMKwEOL2HSA)

## 方法
仮想マシンの設定ファイルは、`/etc/pve/nodes/<node name>/qemu-server` 以下の `.conf` ファイルである。

この設定ファイルを別の場所に移動するか拡張子を `.conf` から変更すれば、Proxmox の Web UI から表示させないようにできる。

例えば、VM 502 を登録解除するには以下のようなコマンドを実行する。

```
# cd /etc/pve/nodes/uranus/qemu-server
# mv 502.conf 502.conf.disabled
```

---

[Usage](../README.md)
