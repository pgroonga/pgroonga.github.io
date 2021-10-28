---
title: "pgroonga_crash_safer.log_pathパラメーター"
upper_level: ../
---

# `pgroonga_crash_safer.log_path`パラメーター

2.3.3で追加。

## 概要

`pgroonga_crash_safer.log_path`パラメーターはログのパスを制御します。これは[`pgroonga.log_path`パラメーター][log-path]の[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]バージョンです。

詳細は[`pgroonga.log_path`パラメーター][log-path]を参照してください。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_crash_safer.log_path = path
```

デフォルト値は[`pgroonga.log_path`パラメーター][log-path]と同じで`$PGDATA/pgroonga.log`です。

## 使い方

ログを`/var/log/pgroonga.log`に出力する例です。

```text
pgroonga_crash_safer.log_path = '/var/log/pgroonga.log'
```

ログを無効にする例です。

```text
pgroonga_crash_safer.log_path = 'none'
```

## 参考

  * [`pgroonga.log_path`パラメーター][log-path]

  * [`pgroonga_crash_safer.log_level`パラメーター][pgroonga-crash-safer-log-level]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[log-path]:log-path.html

[pgroonga-crash-safer-log-level]:pgroonga-crash-safer-log-level.html
