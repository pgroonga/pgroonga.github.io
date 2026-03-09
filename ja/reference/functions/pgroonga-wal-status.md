---
title: pgroonga_wal_status 関数
upper_level: ../
---

# `pgroonga_wal_status` 関数

## 概要

`pgroonga_wal_status` 関数はPGroongaのWALの適用状況を表示します。

PGroongaのWALの最大サイズは、 [`pgroonga.max_wal_size`][max-wal-size] で制限されます。PGroongaのWALが適用される前にたくさんの変更を行うと、未適用のWALが失われる可能性があります。PGroongaのWALは、 ``pgroonga.max_wal_size`` を超える変更があった場合、PGroongaのWALの先頭から上書きされるためです。

この関数を使うことでPGroongaのWALの適用済みのサイズがわかります。したがって、この関数を使うことで未適用のWALの消失を防ぐことができます。

## 構文

この関数の構文は次の通りです。

```text
SETOF RECORD pgroonga_wal_status()
```

この関数は、PGroongaのWALの適用状況を取得します。

以下のようなレコードを返します。

```sql
       name       | current_block | current_offset | current_size | last_block | last_offset | last_size 
------------------+---------------+----------------+--------------+------------+-------------+-----------
 pgrn_memos_index |             1 |            566 |         8758 |          1 |         566 |      8758
```

``current_*`` は適用済みのPGroongaのWALの情報です。

``last_*`` は適用されているかどうかに関わらず、現在存在しているPGroongaのWALの情報を表します。

``*_block`` はブロック数を表します。

``*_offset`` はブロック内の位置を表します。

``*_size`` はPGroongaのWALのサイズを表します。単位はbyteです。

PGroongaがWALをすべて適用している場合は、 current と last は同じ値になります。

通常、プライマリーのデーターベースでは、 current と last は同じ値です。
スタンバイデータベースでは、 [`pgroonga_standby_maintainer` モジュール][standby-maintainer] を使っていない場合、 ``last_*`` の値のみ増加します。

この関数を定期的にスタンバイデータベースで実行することでWALが上書きされているかどうかを確認できます。

## 使い方

サンプルスキーマとデータは次の通りです。

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

## 参考

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

  * [`pgroonga.max_wal_size`パラメーター][max-wal-size]

  * [`pgroonga_standby_maintainer` モジュール][standby-maintainer]

[enable-wal]:../parameters/enable-wal.html

[max-wal-size]:../parameters/max-wal-size.html

[standby-maintainer]:../modules/pgroonga-standby-maintainer.html
