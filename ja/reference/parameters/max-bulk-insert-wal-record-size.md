---
title: "pgroonga.max_bulk_insert_wal_record_sizeパラメーター"
upper_level: ../
---

# `pgroonga.max_bulk_insert_wal_record_size`パラメーター

3.2.5で追加。

## 概要

`pgroonga.max_bulk_insert_wal_record_size`パラメーターはPGroongaのバルクインサート用のカスタムWALレコードの最大サイズを制御します。

このパラメーターは[`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]を使っているときだけ使われます。

これはソフトリミットです。そのため、いくつかのWALレコードはここで指定した値以上のサイズになることがあります。

## 構文

SQLの場合：

```sql
SET pgroonga.max_bulk_insert_wal_record_size = size;
```

`postgresql.conf`の場合：

```text
pgroonga.max_bulk_insert_wal_record_size = size
```

`size`はサイズです。デフォルトの単位はKiBです。サフィックスを指定することで単位を変更できます。たとえば、MiBを使いたい場合は`MB`を指定します。

デフォルトは`16MiB`です。

`0`を指定するとこのソフトリミットを無効にできます。

## 使い方

以下は256MiBを指定する例です。

```text
pgroonga.max_bulk_insert_wal_record_size = 256MB
```

## 参考

  * [`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]

  * [ストリーミングレプリケーション][streaming-replication]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[streaming-replication]:../streaming-replication.html
