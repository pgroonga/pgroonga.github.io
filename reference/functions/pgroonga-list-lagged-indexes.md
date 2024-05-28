---
title: pgroonga_list_lagged_indexes function
upper_level: ../
---

# `pgroonga_list_lagged_indexes` function

## Summary

`pgroonga_list_lagged_indexes` function display a index of PGroonga with unapplied PGroonga WAL (not PostgreSQL WAL).

Specifically, it displays the following cases:

1. If `current_*` and `last_*` in [`pgroonga_wal_status` function][wal-status] are different

   * Displays the applicable PGroonga indexes

2. If `flushed_lsn` and `latest_end_lsn*` in [`pg_stat_wal_receiver`][pg-stat-wal-receiver] are different

   * Displays all PGroonga indexes

## Syntax

Here is the syntax of this function:

```text
SETOF text pgroonga_list_lagged_indexes()
```

It gets the index of PGroonga with unapplied PGroonga WAL (not PostgreSQL WAL).

It returns the following records:

```sql
 pgroonga_list_lagged_indexes
------------------------------
 pgrn_memos_index
 pgrn_tags_index
```

## Usage

```sql
SELECT pgroonga_list_lagged_indexes();
```

## Example

It is assumed that [streaming replication][streaming-replication] and [`pgroonga.enable_wal = yes`][enable-wal] have already been set up.

### Run in primary

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

### Run in standby

PGroonga WAL not applied:

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

PGroonga WAL already applied in some PGroonga indexes:

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

PGroonga WAL is applied to all PGroonga indexes:

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

## See also

  * [`pgroonga_wal_status` function][wal-status]

  * [`pgroonga.enable_wal` parameter][enable-wal]

[enable-wal]:../parameters/enable-wal.html

[pg-stat-wal-receiver]:{{ site.postgresql_doc_base_url.en }}/monitoring-stats.html#MONITORING-PG-STAT-WAL-RECEIVER-VIEW

[streaming-replication]:streaming-replication.html

[wal-status]:pgroonga-wal-status.html
