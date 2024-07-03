---
title: "pgroonga.enable_wal_resource_manager パラメーター"
upper_level: ../
---

# `pgroonga.enable_wal_resource_manager` パラメーター

3.2.1で追加

PostgreSQL 15以上で利用できます。

## 概要

`pgroonga.enable_wal_resource_manager`パラメーターはWALリソースマネージャーを有効にするかどうかを制御します。

WALリソースマネージャーサポートを有効にするとPostgreSQLの[カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers]機能を利用します。

WALリソースマネージャーサポートを有効にすると、WALのディスク書き込みがあるため、更新性能が落ちるはずです。

デフォルト値は`off`です。これはWALを生成しないということです。

## 構文

SQLの場合：

```sql
SET pgroonga.enable_wal_resource_manager = boolean;
```

`postgresql.conf`の場合：

```text
pgroonga.enable_wal_resource_manager = boolean
```

`boolean`は真偽値です。真偽値には`on`、`off`、`true`、`false`、`yes`、`no`のようなリテラルがあります。

## 使い方

以下はWALリソースマネージャーサポートを有効にするSQLの例です。

```sql
SET pgroonga.enable_wal_resource_manager = on;
```

以下はWALリソースマネージャーサポートを有効にする設定の例です。

```text
pgroonga.enable_wal_resource_manager = on
```

## 参考

  * [カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers]

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.ja }}/custom-rmgr.html
