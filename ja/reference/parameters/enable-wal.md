---
title: "pgroonga.enable_walパラメーター"
upper_level: ../
---

# `pgroonga.enable_wal`パラメーター

1.1.6で追加。

## お知らせ

PostgreSQL 15以上であれば、このモジュールの変わりに[`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]をご利用ください。

このモジュールには以下の利点があります。

* スタンバイにおいてリアルタイムでWALが適用されます

* スタンバイにおいてリカバリー中に不安定な状態になることを防げます

  * リカバリー中は接続できなくなります

  * [crash-safer][pgroonga-crash-safer]の場合は、接続はできたがクエリが実行できない状態がありえました

* [レプリケーションスロット][postgresql-replication-slots]と合わせて使うとWALが増え続ける問題を防げます

## 概要

`pgroonga.enable_wal`パラメーターは[WAL]({{ site.postgresql_doc_base_url.ja }}/runtime-config-wal.html)を有効にするかどうかを制御します。

WALサポートを有効にするとPostgreSQLのストリーミングレプリケーション機能を使えます。詳細は[レプリケーション](../replication.html)を参照してください。

WALサポートを有効にすると更新性能が落ちるはずです。これは追加のディスク書き込みが必要になるからです。

デフォルト値は`off`です。これはWALを生成しないということです。

## 構文

SQLの場合：

```sql
SET pgroonga.enable_wal = boolean;
```

`postgresql.conf`の場合：

```text
pgroonga.enable_wal = boolean
```

`boolean`は真偽値です。真偽値には`on`、`off`、`true`、`false`、`yes`、`no`のようなリテラルがあります。

## 使い方

以下はWALサポートを有効にするSQLの例です。

```sql
SET pgroonga.enable_wal = on;
```

以下はWALサポートを有効にする設定の例です。

```sql
pgroonga.enable_wal = on
```

## 参考

  * [レプリケーション](../replication.html)

[postgresql-replication-slots][{{ site.postgresql_doc_base_url.ja }}/warm-standby.html#STREAMING-REPLICATION-SLOTS]

[pgroonga-crash-safer]:../reference/modules/pgroonga-crash-safer.html

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html
