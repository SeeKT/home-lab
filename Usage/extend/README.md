# LVM ディスクの容量拡張
VM の容量を拡張する手順をまとめる。

## 参考
- [【Ubuntu 22.04 LTS Server】LVMディスクを最大容量まで拡張する](https://www.yokoweb.net/2024/03/04/ubuntu-22_04-lts-server-lvm-disk-expand/)
- [Proxmox上の仮想マシンのディスク容量を増やす方法](https://qiita.com/ll_Roki/items/14c4310aaf3be6bc9e31)

## 手順

### Web UI の操作
Hard Disk を選択し、Disk Action > Resize で増分を入力。

### VM 側

#### ストレージを増やす
```
# cfdisk
```

で拡張したいディスクにカーソルを合わせて、Resize を選択。Write > yes で変更を確定して、Quit で抜ける。

#### LVM 
VM で以下コマンドを実行し、LVMディスクを最大容量まで拡張する

```
$ sudo pvresize /dev/sda3
$ sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
$ sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

---

[Usage](../README.md)
