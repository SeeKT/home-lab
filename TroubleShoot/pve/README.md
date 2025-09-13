# PVE 関連のトラブルシューティング

## 事象
VM として ansible をインストールしたところ、Proxmox Node の Web UI が上書きされてしまったのか、アクセスできなくなってしまった。

```
root@uranus.pve.home's password:
Linux VM9000 5.15.108-1-pve #1 SMP PVE 5.15.108-2 (2023-07-20T10:06Z) x86_64
```

VM 9000 が ansible をインストールした VM。VM 9000 に置き換わった？

## 確認
- `/etc/pve` が空
- NAS のマウントが解除されている

## サービスの状況
### pve-cluster
`pve-cluster` が落ちている。

```
root@VM9000:~# systemctl status pve-cluster
× pve-cluster.service - The Proxmox VE cluster filesystem
     Loaded: loaded (/lib/systemd/system/pve-cluster.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Sat 2025-09-13 03:19:05 JST; 6h ago
    Process: 55819 ExecStart=/usr/bin/pmxcfs (code=exited, status=255/EXCEPTION)
        CPU: 6ms

Sep 13 03:19:05 VM9000 systemd[1]: pve-cluster.service: Scheduled restart job, restart counter is at 5.
Sep 13 03:19:05 VM9000 systemd[1]: Stopped pve-cluster.service - The Proxmox VE cluster filesystem.
Sep 13 03:19:05 VM9000 systemd[1]: pve-cluster.service: Start request repeated too quickly.
Sep 13 03:19:05 VM9000 systemd[1]: pve-cluster.service: Failed with result 'exit-code'.
Sep 13 03:19:05 VM9000 systemd[1]: Failed to start pve-cluster.service - The Proxmox VE cluster filesystem.
```

おそらく `/var/lib/pve-cluster/config.db` が開けずに異常終了したと予想される。

```
root@VM9000:~# ls -l /var/lib/pve-cluster/
total 4264
-rw------- 1 root root  180224 Sep  1 13:39 config.db
-rw------- 1 root root   32768 Sep  1 13:42 config.db-shm
-rw------- 1 root root 4144752 Sep  1 13:42 config.db-wal
```

ホスト名が変わっていたので、それを戻す。

```
# hostnamectl set-hostname #{ORIGINALNAME}
# nano /etc/hosts
```

`/etc/hosts` では Proxmox のクラスタのノード名に変更。


```
# systemctl restart corosync
# systemctl restart pve-cluster
# systemctl restart pveproxy
# systemctl restart pvedaemon
```

再起動するとホスト名がもとにもどっていた。ホスト側に `cloud-init` が入っていることを確認。削除した上で再起動すると解決。

```
# dpkg -l | grep cloud-init
# apt purge cloud-init
```

---

[TroubleShoot](../README.md)
