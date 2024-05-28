# スイッチングハブ
実験線用にスイッチングハブを設定する。

VLAN 対応のネットワークスイッチとして、[NETGEAR ギガビット (GS108E)](https://www.netgear.com/jp/business/wired/switches/plus/gs108e/) を用いている。

## 参考
- [タグ VLAN を設定したスイッチ同士の接続](https://www.downloads.netgear.com/files/answer_media/jp/support/switch/VLAN_trunk_setting_ex.pdf)

## 構成
以下のような構成の実験線を実現する。

![](./01_env.drawio.png)

`win10-target` は物理機器で、実験線用の Network Switch で、VLAN 50 と VLAN 100 のポートに接続している。各機器の NIC と IP アドレスの対応を以下に示す。

|機器|NIC|IPアドレス|
|---|---|---|
|`win10-target`|`eth1`|`192.168.100.5/24`|
|`win10-target`|`eth2`|`192.168.50.5/24`|
|`debian-workstation`|`ens19`|`192.168.50.85/24`|
|`debian-workstation`|`ens20`|`192.168.75.85/24`|
|`debian-caldera`|`ens18`|`192.168.50.80/24`|
|`debian-caldera`|`ens19`|`192.168.100.80/24`|

## Proxmox 側の設定
[VLANの設定](../VLAN/README.md) の Open vSwitch を使う方法で設定する。今回は、Compute Node 1 および Compute Node 2 の vmbr1 は OVS Bridge である。

## ネットワークスイッチ側の設定
IEEE 802.1Q のタグVLANを設定する。

上図のように、ポート8をトランクポート、ポート5~7を VLAN 1 (スイッチ管理用)、ポート3~4を VLAN 100 (サイバー攻撃実験用)、ポート1~2を VLAN 50 (実験線管理用) となるように設定する。

### VLAN作成
VLAN > 802.1Q > 拡張 > VLANポートメンバーで、VLAN ID を作成する。

![](./02_create_vlan.png)


### VLANメンバーシップ
各 VLAN に属するポート番号を指定する。今回は以下のように設定する。

- VLAN 1
  - ポート5~7をUに、ポート8をTに変更
  - VLAN 1 のメンバーポートからポート1~4を削除
- VLAN 50
  - ポート1~2をUに、ポート8をTに変更
- VLAN 100
  - ポート3~4をUに、ポート8をTに変更

ここで、U は VLAN タグなし (Untagged) で、T は VLAN タグあり (Tagged) を表す。トランクポートは T で、それ以外のポートは U とする。

### Port VLAN ID (PVID) の設定
PC などから VLAN タグが付与されない通信をスイッチが受信した場合に転送する VLAN ID を設定する。今回は以下のように設定する。

![](./03_pvid.png)


---

[Usage](../README.md)
