---
title: "pgroonga.max_wal_sizeパラメーター"
upper_level: ../
---

# `pgroonga.max_wal_size`パラメーター

2.3.3で追加。

## 概要

`pgroonga.max_wal_size`パラメーターはPGroongaのWALの最大サイズを制御します。

`pgroonga_max_wal_size`パラメーターは[`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]と一緒に使います。プライマリーサーバーで`pgroonga_max_wal_size`パラメーターを指定して、スタンバイサーバーで[`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]を有効にします。

`pgroonga.max_wal_size`パラメーターの値はスタンバイサーバーでWALを適用できるくらい十分大きくする必要があります。もし、`pgroonga.max_wal_size`パラメーターの値が小さいとスタンバイサーバーのデータが壊れます。

## 構文

SQLの場合：

```sql
SET pgroonga.max_wal_size = size;
```

`postgresql.conf`の場合：

```text
pgroonga.max_wal_size = size
```

`size`はサイズです。デフォルトの単位はKiBです。サフィックスを指定することで単位を変更できます。たとえば、MiBを使いたい場合は`MB`を指定します。

デフォルトは`0`です。これはサイズ制限がないということです。

## 使い方

以下は10MiBを指定する例です。

```text
pgroonga.max_wal_size = 10MB
```

## 参考

  * [`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]

 * [ストリーミングレプリケーション][streaming-replication]

[pgroonga-wal-applier]:../modules/pgroonga-wal-applier.html

[streaming-replication]:../streaming-replication.html
