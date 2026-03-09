---
title: pgroonga_wal_status function
upper_level: ../
---

# `pgroonga_wal_status` function

## Summary

`pgroonga_wal_status` function display a status of applying PGroonga's WAL.

The maximum size of PGroonga's WAL is limited by [`pgroonga.max_wal_size`][max-wal-size].
If we execute many modification before PGroonga doesn't apply PGroonga's WAL, not applied PGroonga's WAL may lost.
Because PGroonga's WAL is over writed from the head of it when the size of modification over ``pgroonga.max_wal_size``

We understand the size of applied PGroonga's WAL by this function. Therefore we can prevent lost for not applied PGroonga's WAL.

## Syntax

Here is the syntax of this function:

```text
SETOF RECORD pgroonga_wal_status()
```

It get a status of applying PGroonga's WAL.

It returns the following records:

```sql
       name       | current_block | current_offset | current_size | last_block | last_offset | last_size 
------------------+---------------+----------------+--------------+------------+-------------+-----------
 pgrn_memos_index |             1 |            566 |         8758 |          1 |         566 |      8758
```

``current_*`` show the information of applied PGroonga's WAL.

``last_*`` show the indormation of existing PGroonga's WAL regardless of whether apply or not.

``*_block`` show the number of block.

``*_offset`` show the position in a block.

``*_size`` show the size of PGroonga's WAL. The unit of this parameter is byte.

If PGroonga applied all WAL, values of current and last are same values.

Normally, values of current and last are same values in a primary database.
In a standby database, if we don't use [`pgroonga_standby_maintainer` module][standby-maintainer], values of ``last_*`` increase only.

We can confirm whether overwritten WAL or not by using this function periodically in a standby database.

## Usage

Here are sample schema and data:

```sql
SET pgroonga.enable_wal = yes;
CREATE TABLE memos (
  content text
);
CREATE TABLE tags (
  name text
);
CREATE INDEX pgrn_memos_index ON memos USING PGroonga (content);
CREATE INDEX pgrn_tags_index ON tags USING PGroonga (name);
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

INSERT INTO memos VALUES ('Groonga is fast!');
INSERT INTO tags VALUES ('Groonga');
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
 pgrn_memos_index |             1 |            627 |         8819 |          1 |         627 |      8819
 pgrn_tags_index  |             1 |            609 |         8801 |          1 |         609 |      8801
(2 rows)

INSERT INTO memos VALUES ('PGroonga is also fast!');
INSERT INTO tags VALUES ('PGroonga');
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
 pgrn_memos_index |             1 |            694 |         8886 |          1 |         694 |      8886
 pgrn_tags_index  |             1 |            659 |         8851 |          1 |         659 |      8851
(2 rows)
```

## See also

  * [`pgroonga.enable_wal` parameter][enable-wal]

  * [`pgroonga.max_wal_size` parameter][max-wal-size]

  * [`pgroonga_standby_maintainer` module][standby-maintainer]

[enable-wal]:../parameters/enable-wal.html

[max-wal-size]:../parameters/max-wal-size.html

[standby-maintainer]:../modules/pgroonga-standby-maintainer.html
