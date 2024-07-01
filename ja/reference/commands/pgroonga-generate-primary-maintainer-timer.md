---
title: pgroonga-generate-primary-maintainer-timer.sh コマンド
upper_level: ../
---

# `pgroonga-generate-primary-maintainer-timer.sh` コマンド

3.2.1で追加

## 概要

このコマンドは [`pgroonga-primary-maintainer.sh` コマンド][primary-maintainer] を[systemd/タイマー][systemd-timers] を利用して定期実行するための `timer` ファイルの内容を出力します。

[`pgroonga-generate-primary-maintainer-service.sh` コマンド][generate-primary-maintainer-service]で生成したサービスファイルと合わせて利用します。

## 使い方

```
Options:
--time:
  Specify run time,
  Example: --time 2:00 --time 3:30 ...
--help:
  Display help text and exit.
```

* `--time`

  * 定期実行の開始時間を指定します

  * 複数の時間を指定できます

## 実行例

出力をリダイレクトして設定ファイルを生成します。

Note:

* 事前に [`pgroonga-generate-primary-maintainer-service.sh` コマンド][generate-primary-maintainer-service] で `.service` ファイルを作成してください

  * `NAME.service` と `NAME.timer` の `NAME` の部分は同一にする必要があります

* 環境によってコマンドのパスは変わります

### オプション

1:15 と 23:45 に実行する設定の例です。

### ファイル作成

```console
$ sudo -u postgres -H /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-timer.sh \
  --time 1:15 \
  --time 23:45 | \
  sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.timer
# How to install:
#   /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-timer.sh | sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.timer
#   sudo -H systemctl daemon-reload
#
# Usage:
#
#   Enable:  sudo -H systemctl enable --now pgroonga-primary-maintainer.timer
#   Disable: sudo -H systemctl disable --now pgroonga-primary-maintainer.timer
[Unit]
Description=PGroonga primary maintainer
[Timer]
OnCalendar=*-*-* 1:15:00
OnCalendar=*-*-* 23:45:00
[Install]
WantedBy=timers.target
```

### systemd の Timer を有効にする

```
$ sudo -H systemctl enable --now pgroonga-primary-maintainer.timer
```

### ステータスチェック

```
$ sudo -H systemctl status pgroonga-primary-maintainer.timer
● pgroonga-primary-maintainer.timer - PGroonga primary maintainer
   Loaded: loaded (/usr/lib/systemd/system/pgroonga-primary-maintainer.timer; enabled; vendor preset: disabled)
   Active: active (waiting) since Fri 2024-06-28 08:28:58 UTC; 14min ago
  Trigger: Fri 2024-06-28 23:45:00 UTC; 15h left

Jun 28 08:28:58 temp systemd[1]: Started PGroonga primary maintainer.
```

### systemd の Timer を無効にする

```
$ sudo -H systemctl disable --now pgroonga-primary-maintainer.timer
```

## 参考

  * [`pgroonga-primary-maintainer.sh` コマンド][primary-maintainer]

  * [`pgroonga-generate-primary-maintainer-service.sh` コマンド][generate-primary-maintainer-service]

  * [systemd/タイマー][systemd-timers]

[primary-maintainer]:pgroonga-primary-maintainer.html

[generate-primary-maintainer-service]:pgroonga-generate-primary-maintainer-service.html

[systemd-timers]:https://wiki.archlinux.jp/index.php/Systemd/%E3%82%BF%E3%82%A4%E3%83%9E%E3%83%BC

[systemd-on-failure]:https://wiki.archlinux.jp/index.php/Systemd#%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%81%AE%E5%A4%B1%E6%95%97%E3%82%92%E9%80%9A%E7%9F%A5%E3%81%99%E3%82%8B
