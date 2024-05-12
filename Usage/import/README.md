# 既存の仮想マシンのインポート
`vmdk` 形式でインポートする。

## 参考
- [VirtualBoxからProxmox VEに仮想マシンを移行した話](https://qiita.com/tomgoodsun/items/e8ff6dc8d6679c0fe4c7)
- [proxmoxにvirtualboxのマシンをインポートする](https://zarat.hatenablog.com/entry/2020/06/26/195540)

## 手順
1. `vmdk` ファイルを Proxmox のノードに転送
2. `vmdk` ファイルをインポート
   ```
   # qm importdisk <vmid> <path of disk> <storage> -format [raw|qcow2]
   ```


---

[Usage](../README.md)
