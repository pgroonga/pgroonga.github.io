---
title: pgroonga_list_lagged_indexes function
upper_level: ../
---

# `pgroonga_list_lagged_indexes` 関数

## 概要

`pgroonga_list_lagged_indexes` 関数は未適用の（PostgreSQLのWALではなく）PGroongaのWALがあるPGroongaのインデックスを表示します。

具体的には以下の場合に表示します。

1. [`pgroonga_wal_status` function][wal-status] の `current_*` と `last_*` が異なる場合

   * 該当のPGroongaのインデックスを表示します

2. [`pg_stat_wal_receiver`][pg-stat-wal-receiver] の `flushed_lsn` と `latest_end_lsn` が異なる場合

   * すべてのGroongaのインデックスを表示します

## 構文

この関数の構文は次の通りです。

```text
SETOF text pgroonga_list_lagged_indexes()
```

この関数は未適用の（PostgreSQLのWALではなく）PGroongaのWALがあるPGroongaのインデックスを取得します。

以下のようなレコードを返します。

```sql
 pgroonga_list_lagged_indexes
------------------------------
 pgrn_memos_index
 pgrn_tags_index
```

## 使い方

```sql
SELECT pgroonga_list_lagged_indexes();
```

## 実行例

[ストリーミングレプリケーションの設定][streaming-replication]や [`pgroonga.enable_wal = yes`][enable-wal] の設定は済んでいるものとして例を記載します。

### プライマリーで実行

```sql
CREATE TABLE memos (
  content text
);
CREATE TABLE tags (
  name text
);
CREATE INDEX pgrn_memos_index ON memos USING PGroonga (content);
CREATE INDEX pgrn_tags_index ON tags USING PGroonga (name);
```

### スタンバイで実行

PGroongaのWALが未適用の状態。

```sql
SELECT name,
       current_block,
       current_offset,
       current_size,
       last_block,
       last_offset,
       last_size
  FROM pgroonga_wal_status();
       name       | current_block | current_offset | current_size | last_block | last_offset | last_size 
------------------+---------------+----------------+--------------+------------+-------------+-----------
 pgrn_memos_index |             0 |              0 |            0 |          1 |         566 |      8758
 pgrn_tags_index  |             0 |              0 |            0 |          1 |         560 |      8752
(2 rows)

SELECT pgroonga_list_lagged_indexes();
 pgroonga_list_lagged_indexes
------------------------------
 pgrn_memos_index
 pgrn_tags_index
(2 rows)
```

一部のPGroongaインデックスでPGroongaのWALが適用済。

```sql
SELECT * FROM tags WHERE name &@ 'dummy';
 name
------
(0 rows)

SELECT name,
       current_block,
       current_offset,
       current_size,
       last_block,
       last_offset,
       last_size
  FROM pgroonga_wal_status();
       name       | current_block | current_offset | current_size | last_block | last_offset | last_size
------------------+---------------+----------------+--------------+------------+-------------+-----------
 pgrn_memos_index |             0 |              0 |            0 |          1 |         566 |      8758
 pgrn_tags_index  |             1 |            560 |         8752 |          1 |         560 |      8752
(2 rows)

SELECT pgroonga_list_lagged_indexes();
 pgroonga_list_lagged_indexes
------------------------------
 pgrn_memos_index
(1 row)
```

すべてのPGroongaインデックスでPGroongaのWALが適用済。

```sql
SELECT pgroonga_wal_apply();
 pgroonga_wal_apply
--------------------
                  7
(1 row)

SELECT name,
       current_block,
       current_offset,
       current_size,
       last_block,
       last_offset,
       last_size
  FROM pgroonga_wal_status();
       name       | current_block | current_offset | current_size | last_block | last_offset | last_size
------------------+---------------+----------------+--------------+------------+-------------+-----------
 pgrn_memos_index |             1 |            566 |         8758 |          1 |         566 |      8758
 pgrn_tags_index  |             1 |            560 |         8752 |          1 |         560 |      8752
(2 rows)

SELECT pgroonga_list_lagged_indexes();
 pgroonga_list_lagged_indexes
------------------------------
(0 rows)
```

## 参考

  * [`pgroonga_wal_status`関数][wal-status]

  * [`pgroonga.enable_wal` パラメーター][enable-wal]

[enable-wal]:../parameters/enable-wal.html

[pg-stat-wal-receiver]:{{ site.postgresql_doc_base_url.ja }}/monitoring-stats.html#MONITORING-PG-STAT-WAL-RECEIVER-VIEW

[streaming-replication]:streaming-replication.html

[wal-status]:pgroonga-wal-status.html
