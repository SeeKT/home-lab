# LVM ディスクの容量拡張
VM の容量を拡張する手順をまとめる。

## 参考
- [【Ubuntu 22.04 LTS Server】LVMディスクを最大容量まで拡張する](https://www.yokoweb.net/2024/03/04/ubuntu-22_04-lts-server-lvm-disk-expand/)

## 手順
VM で以下コマンドを実行し、LVMディスクを最大容量まで拡張する

```
$ sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
$ sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

---

[Usage](../README.md)
