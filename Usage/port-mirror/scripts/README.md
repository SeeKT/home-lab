# Proxmox (Open vSwitch) のポートミラーリング設定用スクリプト

Open vSwitch のポートミラーリング設定のためのコマンドを出力するためのスクリプトを作成した。

## 参考
- [Proxmox VM Bridge Port Mirror](https://codingpackets.com/blog/proxmox-vm-bridge-port-mirror/)

## 前提
- Open vSwitch インストール済
- 設定用 csv ファイル作成済 (例：[vmbr1.csv](vmbr1.csv))

## スクリプト
[port-mirror.sh](port-mirror.sh) を作成。

```
# ./port-mirror.sh #{CSVPATH} #{BRIDGE} #{SELECTVLAN} #{OUTPUTVLAN}
```

|パラメータ|意味|
|---|---|
|`CSVPATH`|ミラーリング設定する仮想ブリッジの情報を記載した CSV ファイル|
|`BRIDGE`|ミラーリング設定する仮想ブリッジ|
|`SELECTVLAN`|ミラーリング対象の VLAN タグ|
|`OUTPUTVLAN`|ミラー先の VLAN タグ|

## 実行例
```
# ./port-mirror.sh vmbr1.csv vmbr1 1100 205
Execute the following 1 commands...
ovs-vsctl -- set bridge vmbr1 mirrors=@vmbr1-m-tap505i4 --  --id=@tap411i0 get Port tap411i0 -- --id=@tap420i1 get Port tap420i1 -- --id=@tap505i4 get Port tap505i4 -- --id=@vmbr1-m-tap505i4 create Mirror name=vmbr1-mirror-tap505i4 select-dst-port=@tap411i0,@tap420i1 select-src-port=@tap411i0,@tap420i1 output-port=@tap505i4 select-vlan=1100 output-vlan=205
```

## 補足
記載されたコマンドを実行する前に以下コマンドを実行することを推奨。

```
# ovs-vsctl clear bridge #{BRIDGE} mirrors 
```

---

[port-mirror](../README.md)
