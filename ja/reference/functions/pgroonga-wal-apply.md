---
title: pgroonga_wal_apply関数
upper_level: ../
---

# `pgroonga_wal_apply`関数

## 概要

`pgroonga_wal_apply`関数は未適用のWALを適用します。通常、この関数を使う必要はありません。なぜなら、PGroongaは`INSERT`、`DELETE`、`UPDATE`、`SELECT`のときなど自動的に未適用のWALを適用するからです。

## 構文

この関数の構文は次の通りです。

```text
bigint pgroonga_wal_apply(pgroonga_index_name)
```

`pgroonga_index_name`は`text`型の値です。未適用のWALを適用したいPGroognaのインデックスの名前を指定します。

適用した操作数を返します。

この関数の別の構文は次の通りです。

```text
bigint pgroonga_wal_apply()
```

すべてのPGroongaのインデックスに対して未適用のWALを適用します。

適用した操作数を返します。

## 使い方

サンプルスキーマとデータは次の通りです。

```sql
SET pgroonga.enable_wal = yes;

CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content);

INSERT INTO memos VALUES ('PGroonga (PostgreSQL+Groonga) is great!');
```

PGroongaのデータベースが壊れた状況を再現します。

```sql
SELECT pgroonga_command('delete',
                        ARRAY[
                          'table', 'IndexStatuses',
                          'key', 'pgroonga_memos_index'::regclass::oid::text
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
SELECT pgroonga_command('table_remove',
                        ARRAY[
                          'name', 'Lexicon' ||
                                  'pgroonga_memos_index'::regclass::oid ||
                                  '_0'
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
SELECT pgroonga_command('table_remove',
                        ARRAY[
                          'name', pgroonga_table_name('pgroonga_memos_index')
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
```

これで未適用のWALがある状態になりました。明示的に未適用のWALを適用できます。

```sql
SELECT pgroonga_wal_apply('pgroonga_memos_index');
--  pgroonga_wal_apply 
-- --------------------
--                   7
-- (1 row)
```

PGroongaのインデックスの名前を省略できます。PGroongaのインデックスの名前を省略すると、すべてのPGroongaのインデックスのすべての未適用のWALを明示的に適用します。

```sql
SELECT pgroonga_wal_apply();
--  pgroonga_wal_apply 
-- --------------------
--                   7
-- (1 row)
```

## 参考

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

  * [`pgroonga_wal_truncate`関数][wal-truncate]

[enable-wal]:../parameters/enable-wal.html

[wal-truncate]:pgroonga-wal-truncate.html
