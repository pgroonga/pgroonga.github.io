---
title: pgroonga_wal_set_applied_position関数
upper_level: ../
---

# `pgroonga_wal_set_applied_position`関数

3.1.5で追加。

## 概要

`pgroonga_wal_set_applied_position`関数はすでに適用済みのWALの位置を設定します。通常、この関数を使う必要はありません。なぜなら適用済みのWALの位置が不正な値にならないからです。

## 構文

この関数の構文は次の通りです。

```text
bool pgroonga_wal_set_applied_position()
bool pgroonga_wal_set_applied_position(pgroonga_index_name)
bool pgroonga_wal_set_applied_position(block, offset)
bool pgroonga_wal_set_applied_position(pgroonga_index_name, block, offset)
```

`pgroonga_index_name`は`text`型の値です。適用済みのWALの位置を設定するPGroongaのインデックス名を指定します。省略するとすべてのPGroongaのインデックスが対象になります。

`block`と`offset`は`bigint`型の値です。これらは位置を指定します。`block`が対象のブロック番号で、`offset`がそのブロック内での位置です。省略すると最後のブロックとオフセットを設定します。最後のブロックとオフセットを設定するということはすべてのWALを適用済みとすることになります。通常、これらを省略します。なぜなら妥当なブロックとオフセットを指定することは難しいからです。

なお、[`pgroonga_wal_status`関数][wal-status]を使うと現在のWALの位置を確認できます。

成功時は`true`を返し、失敗時は`false`を返します。しかし、`false`が返されることはないでしょう。なぜなら失敗時はエラーが発生するからです。

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

PGroongaのインデックスが削除されたがWALは生きている状況を再現します。

```sql
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

この状況では、このPGroongaのインデックスを使う`SELECT`がエラーを発生させます。

```sql
SET enable_seqscan = no;
SELECT * FROM memos WHERE content &@~ 'PGroonga';
--- ERROR:  pgroonga: object isn't found: <Sources17853>
```

この削除されたインデックスは既存のWALを再適用することで再作成できます。これをするためには、適用済みのWALの位置を先頭（`block`と`offset`が`0`）に設定します。

```sql
SELECT pgroonga_wal_set_applied_position('pgroonga_memos_index', 0, 0);
--  pgroonga_wal_set_applied_position 
-- -----------------------------------
--  t
-- (1 row)
```

このPGroongaのインデックスを使うと自動で未適用のWALが適用されます

```sql
SELECT * FROM memos WHERE content &@~ 'PGroonga';
--                  content                 
-- -----------------------------------------
--  PGroonga (PostgreSQL+Groonga) is great!
-- (1 row)
```

## 参考

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

  * [`pgroonga_wal_status`関数][wal-status]

[enable-wal]:../parameters/enable-wal.html

[wal-status]:pgroonga-wal-status.html
