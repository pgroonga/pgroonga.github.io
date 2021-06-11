---
title: "pgroonga.enable_walパラメーター"
upper_level: ../
---

# `pgroonga.enable_wal`パラメーター

1.1.6で追加。

## 概要

`pgroonga.enable_wal`パラメーターは[WAL]({{ site.postgresql_doc_base_url.ja }}/runtime-config-wal.html)を有効にするかどうかを制御します。

PGroongaはPostgreSQL 9.6以降で使う場合はWALをサポートしています。PostgreSQL 9.5以前で使う場合は`pgroonga.enable_wal`パラメーターを設定しても意味はありません。

WALサポートを有効にするとPostgreSQLのストリーミングレプリケーション機能を使えます。詳細は[レプリケーション](../replication.html)を参照してください。

WALサポートを有効にすると更新性能が落ちるはずです。これは追加のディスク書き込みが必要になるからです。

デフォルト値は`off`です。これは、PGroongaはPostgreSQL 9.6以降で使っている場合でもWALを生成しないということです。この機能が安定したらデフォルトで`on`になる予定です。

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
