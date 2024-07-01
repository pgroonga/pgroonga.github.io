---
title: pgroonga-generate-primary-maintainer-{service,timer}.sh コマンド
upper_level: ../
---

# `pgroonga-generate-primary-maintainer-{service,timer}.sh` コマンド

3.2.1で追加

## 概要

[`pgroonga-primary-maintainer.sh`][primary-maintainer] を systemd の Timer を使って定期的に実行するための設定ファイルの内容を出力します。

* `pgroonga-generate-primary-maintainer-service.sh`

  * `.service` ファイルの設定内容を出力します

* `pgroonga-generate-primary-maintainer-timer.sh`

  * `.timer` ファイルの設定内容を出力します

## 使い方

### `pgroonga-generate-primary-maintainer-service.sh` コマンド

```
Options:
--pgroonga-primary-maintainer-command:
  Specify the path to `pgroonga-primary-maintainer.sh`
  (default: )
--threshold:
  If the specified value is exceeded, `REINDEX INDEX CONCURRENTLY` is run.
  (default: 1G)
--environment
  Connection information such as `dbname` should be set in environment variables.
  See also: https://www.postgresql.org/docs/current/libpq-envars.html"
  Example: --environment KEY1=VALUE1 --environment KEY2=VALUE2 ...
--psql:
  Specify the path to `psql` command.
--on-failure-service:
  Run SERVICE on failure
--help:
  Display help text and exit.
```

* `--pgroonga-primary-maintainer-command`

  * [`pgroonga-primary-maintainer.sh` command][primary-maintainer] のパスを指定します

* `--threshold`

  * しきい値を指定します

  * 詳細は [`pgroonga-primary-maintainer.sh` コマンド][primary-maintainer] をご確認ください

* `--environment`

  * DBの接続情報を環境変数で指定します

  * 詳細は [`pgroonga-primary-maintainer.sh` コマンド][primary-maintainer] をご確認ください

* `--psql`

  * `psql` コマンドのパスを指定します

  * 詳細は [`pgroonga-primary-maintainer.sh` コマンド][primary-maintainer] をご確認ください

* `--on-failure-service`

  * 実行に失敗したときの通知先を指定します

  * 詳細は [サービスの失敗を通知する][systemd-on-failure] をご確認ください

### `pgroonga-generate-primary-maintainer-timer.sh` コマンド

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

`NAME.service` と `NAME.timer` の `NAME` の部分は同一にする必要があります。

環境によってコマンドのパスは変わります。

### `.service` ファイルの作成

* [`pgroonga-primary-maintainer.sh` command][primary-maintainer] のパスを指定します

  * `--pgroonga-primary-maintainer-command /usr/pgsql-12/bin/pgroonga-primary-maintainer.sh`

* DBの接続情報を環境変数で指定します

  * `--environment PGHOST=example.com`

  * `--environment PGDATABASE=test_database`

* しきい値を10GBで指定

  * `--threshold 10G`

#### ファイル作成

```console
$ sudo -u postgres -H /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-service.sh \
  --pgroonga-primary-maintainer-command /usr/pgsql-12/bin/pgroonga-primary-maintainer.sh \
  --environment PGHOST=example.com \
  --environment PGDATABASE=test_database \
  --threshold 10G | \
  sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.service
# How to install:
#   /usr/pgsql-12/bin/pgroonga-generate-primary-maintainer-service.sh | sudo -H tee /lib/systemd/system/pgroonga-primary-maintainer.service
[Unit]
Description=PGroonga primary maintainer

[Service]
Type=oneshot
User=postgres
Group=postgres
Environment=PGHOST=example.com PGDATABASE=test_database
ExecStart=/usr/pgsql-12/bin/pgroonga-primary-maintainer.sh --threshold 10G
[Install]
WantedBy=multi-user.target
```

#### テスト実行とステータスチェック

注意! しきい値を超えたWALがあると `REINDEX` が実際に動きます。

```console
$ sudo -H systemctl start pgroonga-primary-maintainer.service
```

```console
$ sudo -H systemctl status pgroonga-primary-maintainer.service
● pgroonga-primary-maintainer.service - PGroonga primary maintainer
   Loaded: loaded (/usr/lib/systemd/system/pgroonga-primary-maintainer.service; disabled; vendor preset: disabled)
  Drop-In: /run/systemd/system/pgroonga-primary-maintainer.service.d
           └─zzz-lxc-service.conf
   Active: inactive (dead) since Fri 2024-06-28 08:36:27 UTC; 4min 50s ago
  Process: 21035 ExecStart=/usr/pgsql-12/bin/pgroonga-primary-maintainer.sh --threshold 10G (code=exited, status=0/SUCCESS)
 Main PID: 21035 (code=exited, status=0/SUCCESS)

Jun 28 08:36:26 temp systemd[1]: Starting PGroonga primary maintainer...
Jun 28 08:36:26 temp pgroonga-primary-maintainer.sh[21035]: Run 'REINDEX INDEX CONCURRENTLY memos_content'
Jun 28 08:36:26 temp pgroonga-primary-maintainer.sh[21047]: Fri Jun 28 08:36:26 UTC 2024
Jun 28 08:36:27 temp pgroonga-primary-maintainer.sh[21048]: REINDEX
Jun 28 08:36:27 temp pgroonga-primary-maintainer.sh[21051]: Fri Jun 28 08:36:27 UTC 2024
Jun 28 08:36:27 temp systemd[1]: pgroonga-primary-maintainer.service: Succeeded.
Jun 28 08:36:27 temp systemd[1]: Started PGroonga primary maintainer.
```

### `.timer` ファイルの作成

1:15 と 23:45 に実行する設定の例です。

#### ファイル作成

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

  * [systemd/タイマー][systemd-timers]

[primary-maintainer]:pgroonga-primary-maintainer.html

[systemd-timers]:https://wiki.archlinux.jp/index.php/Systemd/%E3%82%BF%E3%82%A4%E3%83%9E%E3%83%BC

[systemd-on-failure]:https://wiki.archlinux.jp/index.php/Systemd#%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%81%AE%E5%A4%B1%E6%95%97%E3%82%92%E9%80%9A%E7%9F%A5%E3%81%99%E3%82%8B
