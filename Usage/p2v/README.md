# P2V

Windows マシンの P2V の方法 (to Proxmox) を検証する。

## リンク
- [Clonezilla](./clonezilla/README.md)
- [Disk2vhd](./disk2vhd/README.md)

## 注意点
- Windows の仮想化の場合は、VM 側のハードウェアやオプションの設定を変更しなければ起動できない可能性がある
- VM 側の設定で Network Device を追加しても VM に認識されない。おそらく [Windows VirtIO Drivers](https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers) をインストールする必要がある

---

[Usage](../README.md)
