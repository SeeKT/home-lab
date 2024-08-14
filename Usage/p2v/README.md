# P2V

Windows マシンの P2V の方法 (to Proxmox) を検証する。

## リンク
- [Clonezilla](clonezilla/)
- [Disk2vhd](disk2vhd/)

## 注意点
- Windows の仮想化の場合は、VM 側のハードウェアやオプションの設定を変更しなければ起動できない可能性がある
- VM 側の設定で Network Device を追加しても VM に認識されない。おそらく [Windows VirtIO Drivers](https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers) をインストールする必要がある
  - 上記、原因は NIC のモデルを Realtek RTL8139 にしていないことだった (参考：[Proxmox7 を試してみる　その５　Windows10(migration)](https://qiita.com/murachi1208/items/065406163c71b8a593aa))

---

[Usage](../README.md)
