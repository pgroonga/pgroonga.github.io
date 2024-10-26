---
title: "pgroonga.enable_wal_resource_manager パラメーター"
upper_level: ../
---

# `pgroonga.enable_wal_resource_manager` パラメーター

3.2.1で追加

PostgreSQL 15以上で利用できます。

## 概要

`pgroonga.enable_wal_resource_manager`パラメーターはWALリソースマネージャーを有効にするかどうかを制御します。

WALリソースマネージャーサポートを有効にすると、PGroongaのインデックスを更新するときにPGroongaのWALリソースマネージャー用のWALを生成します。詳細は[WALリソースマネージャーを使ったストリーミングレプリケーション][streaming-replication-wal-resource-manager]を参照してください。

WALリソースマネージャーサポートを有効にすると、WALのディスク書き込みがあるため、更新性能が落ちるはずです。

デフォルト値は`off`です。これはWALを生成しないということです。

[`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager] と一緒に使います。

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

  * [`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]

  * [カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.ja }}/custom-rmgr.html

[streaming-replication-wal-resource-manager]:../streaming-replication-wal-resource-manager.html
