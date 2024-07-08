---
title: "pgroonga_wal_resource_manager.log_path パラメーター"
upper_level: ../
---

# `pgroonga_wal_resource_manager.log_path` パラメーター

3.2.1で追加

## 概要

`pgroonga_wal_resource_manager.log_path` パラメーターはログのパスを制御します。これは [`pgroonga.log_path`パラメーター][log-path]の[`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]バージョンです。

詳細は[`pgroonga.log_path`パラメーター][log-path]を参照してください。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_wal_resource_manager.log_path = path
```

デフォルト値は[`pgroonga.log_path`パラメーター][log-path]と同じで`$PGDATA/pgroonga.log`です。

## 使い方

ログを`/var/log/pgroonga.log`に出力する例です。

```text
pgroonga_wal_resource_manager.log_path = '/var/log/pgroonga.log'
```

ログを無効にする例です。

```text
pgroonga_wal_resource_manager.log_path = 'none'
```

## 参考

  * [`pgroonga.log_path`パラメーター][log-path]

  * [`pgroonga_wal_resource_manager.log_level`パラメーター][pgroonga-wal-resource-manager-log-level]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[log-path]:log-path.html

[pgroonga-wal-resource-manager-log-level]:pgroonga-wal-resource-manager-log-level.html
