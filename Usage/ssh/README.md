# ssh 関連メモ

- [ssh 関連メモ](#ssh-関連メモ)
  - [公開鍵認証にする](#公開鍵認証にする)
  - [tmux を使う](#tmux-を使う)


## 公開鍵認証にする

以降、SSH Server 側の設定

```
echo '#{公開鍵}' >> authorized_keys
```

```
# nano /etc/ssh/sshd_config
```

以下のように編集

```
PubkeyAuthentication yes
PasswordAuthentication no  
```

```
# systemctl restart ssh
```

## tmux を使う
参考: [とほほのtmux入門](https://www.tohoho-web.com/ex/tmux.html)

tmux を使うと、ターミナルを終了してもセッションが維持される。

---

[Top](../../README.md)
