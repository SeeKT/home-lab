# Active Directory の構築

- [Active Directory の構築](#active-directory-の構築)
  - [参考](#参考)
  - [構築](#構築)
    - [Windows Server のダウンロード](#windows-server-のダウンロード)
    - [VMの作成](#vmの作成)
    - [インストール](#インストール)
    - [初期設定](#初期設定)
    - [AD のインストール](#ad-のインストール)
    - [AD ユーザの作成](#ad-ユーザの作成)
    - [グループの作成](#グループの作成)
    - [AD への追加](#ad-への追加)
      - [Windows 10](#windows-10)
      - [Windows 7](#windows-7)

## 参考
- [ハッカーの技術書](http://www.ruffnex.net/kuroringo/HackerTechnical/)
- [Windows 2019 guest best practices](https://pve.proxmox.com/wiki/Windows_2019_guest_best_practices)
- [Proxmox上でWindows Server 2022を立ち上げてみた](https://qiita.com/yusaku-creative/items/74e0f4f88229a167d575)
- [WindowsServer2019でActiveDirectoryを構成する](https://qiita.com/yuichi1992_west/items/a3c6bc33a85895da47dd)

## 構築
### Windows Server のダウンロード
今回は [Windows Server 2019](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019) の検証版をダウンロードする。今回は ISO をダウンロードする。さらに、[Windows VirtIO Drivers](https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers) の安定版 (2024/11/10 時点では 0.1.262) をダウンロードする。

また、ダウンロードした ISO を Proxmox にアップロードしておく。

### VMの作成
Proxmox 上に VM を作成する。

OS 選択の際に Windows 2019 が含まれるものを選び、VirtIO drivers としてダウンロードしたドライバの ISO を追加する。

![](fig/01_create_vm.png)

BIOS は UEFI とする。

![](fig/02_bios.png)

Hard Disk を SCSI として、ディスク容量を要件以上にする (今回は 128GB)。また、Cache は Write back として Discard にチェックを入れる。

![](fig/03_harddisk.png)

CPU とメモリも要件以上で割り当てる。また、ネットワークは VirtIO (paravirtualized) として割り当てる。

![](fig/04_network.png)

### インストール
VM を起動し、OS インストール作業を進める。起動前に Boot Order を変更し、OS の ISO が先頭になるようにする。

セットアップウィザードが起動したら、指示に従いインストールを進める。

![](fig/05_setup_wizard.png)

![](fig/06_install.png)

今回は、Windows Server 2019 Standard Evaluation (デスクトップエクスペリエンス) を選択する。

![](fig/06_os.png)

![](fig/07_license.png)

インストールの種類はカスタムにする。

![](fig/08_type.png)

![](fig/09_location.png)

インストール場所を聞かれるときにドライバーの読み込み > 参照に進み VirtIO のドライバを読み込む。以下ドライバを読み込む。

- Hard disk: `vioscsi\2k19\amd64`
- Network: `NetKVM\2k19\amd64`
- Memory Ballonning: `Ballon\2k19\amd64`

![](fig/11_vioscsi.png)

![](fig/12_netkvm.png)

![](fig/13_ballon.png)

すべて読み込んだら次に進み、インストールする。

![](fig/14_installation_process.png)

### 初期設定
インストール完了後、パスワードの設定を行うとログインできるようになる。今回は、`Passw0rd!` というパスワードに設定した。

![](fig/15_password.png)

![](fig/16_windowsserver.png)

### AD のインストール
サーバーマネージャーを用いて設定する。

- サーバーマネージャー > 役割と機能の追加
- 開始する前に：次へ
- インストールの種類：役割ベースまたは機能ベースのインストール > 次へ
- サーバーの選択：サーバープールからサーバーを選択 > 次へ
- サーバーの役割：Active Directry ドメインサービスを選択 > 機能の追加 > 次へ
- 機能：次へ
- AD DS: 次へ
- 確認：インストール

![](fig/17_ad.png)

インストール後、「このサーバーをドメインコントローラーに昇格する」をクリックする。

![](fig/18_domaincontroller.png)

- 配置構成：新しいフォレストを追加する
  - ルートドメイン名：任意 (今回は `ad.pve.exp`)
- ドメインコントローラーオプション
  - フォレストの機能レベル：Windows Server 2012 R2
  - ドメインの機能レベル：Windows Server 2012 R2
  - ドメインコントローラの機能：DNSサーバーにチェック
  - DSRMのパスワード：任意
  - DNS オプション：次へ
- 追加オプション
  - NetBIOSドメイン名：NetBIOS名 (今回は `AD`)
- パス：デフォルト値で次へ
- オプションの確認：次へ
- 前提条件のチェック：合格したことを確認しインストール

インストール後、自動的に再起動される。

### AD ユーザの作成
ツール > Active Directory ユーザーとコンピューター > ドメインを展開し Users で右クリック > 新規作成 > ユーザー でユーザを作成。

![](fig/19_user.png)

パスワードのオプションを変更して作成完了。

### グループの作成
ツール > Active Directory ユーザーとコンピューター > ドメインを展開し Users で右クリック > 新規作成 > グループ でグループを作成。

![](fig/21_group.png)

グループにユーザを追加する。

![](fig/22_user_group.png)

### AD への追加
#### Windows 10
コントロールパネル > システムとセキュリティ > システム > システムの詳細設定 > コンピュータ名 > 変更 > 所属するグループにドメインを追加する

![](fig/23_join.png)

ドメイン参加後に再起動すると、ドメインのユーザとしてログイン可能。


![](fig/24_domain.png)

#### Windows 7
コントロールパネル > システムとセキュリティ > システム > コンピュータ名、ドメインおよびワークグループの設定 > 設定の変更 > 変更

![](fig/25_join_win7.png)

ドメイン参加後に再起動すると、ドメインのユーザとしてログイン可能。

![](fig/26_win7_domain.png)

---

[Application](../README.md)
