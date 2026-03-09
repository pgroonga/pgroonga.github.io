---
title: "pgroonga_wal_resource_manager.log_level パラメーター"
upper_level: ../
---

# `pgroonga_wal_resource_manager.log_level` パラメーター

3.2.1で追加

## 概要

`pgroonga_wal_resource_manager.log_level` パラメーターはどのログを記録するかを制御します。これは [`pgroonga.log_level` パラメーター][log-level] の[`pgroonga_wal_resource_manager` モジュール][pgroonga-wal-resource-manager] バージョンです。

詳細は[`pgroonga.log_level`パラメーター][log-level]を参照してください。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_wal_resource_manager.log_level = level
```

指定できるレベルは[`pgroonga.log_level`パラメーター][log-level]を参照してください。

## 使い方

ログを無効にする例です。

```text
pgroonga_wal_resource_manager.log_level = none
```

ほとんどのログメッセージを有効にする例です。

```text
pgroonga_wal_resource_manager.log_level = debug
```

## 参考

  * [`pgroonga.log_level`パラメーター][log-level]

  * [`pgroonga_wal_resource_manager.log_path`パラメーター][pgroonga-wal-resource-manager-log-path]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[log-level]:log-level.html

[pgroonga-wal-resource-manager-log-path]:pgroonga-wal-resource-manager-log-path.html
