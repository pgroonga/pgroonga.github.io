---
title: pgroonga_index_column_name 関数
upper_level: ../
---

# `pgroonga_index_column_name` 関数

2.2.6で追加。

## 概要

`pgroonga_index_column_name`関数はPGroongaのインデックス名をGroongaのインデックスカラム名に変換します。Groongaのインデックスカラム名は[`pgroonga_command`関数][command]で[`object_inspect` Groongaコマンド][groonga-object-inspect]を使うときに有用です。PGroongaのインデックスに対して`object_inspect` Groongaコマンドを使うときはGroongaのインデックスカラム名が必要です。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga_index_column_name(pgroonga_index_name, column_name)
text pgroonga_index_column_name(pgroonga_index_name, column_index)
```

`pgroonga_index_name`は`text`型の値です。これはGroongaのインデックスカラム名に変換したいインデックス名です。このインデックスは`USING pgroonga`付きで作られたインデックスでなければいけません。

`column_name`は`text`型の値です。対象のPGroongaのインデックス内の対象のカラム名を指定します。

`column_index`は`int4`型の値です。これは対象のPGroongaのインデックス内の対象カラムの位置です。最初のカラムの位置は0です。

## 使い方

以下はサンプルスキーマです。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);
CREATE INDEX pgroonga_index
          ON memos
       USING pgroonga (title, content, tag);
```

以下は`column_index`を使う例です。

```sql
SELECT pgroonga_index_column_name('pgroonga_index', 2);
--  pgroonga_index_column_name 
-- ----------------------------
--  Lexicon17780_2.index
-- (1 row)
```

以下は`column_name`を使う例です。

```sql
SELECT pgroonga_index_column_name('pgroonga_index', 'tag');
--  pgroonga_index_column_name 
-- ----------------------------
--  Lexicon17780_2.index
-- (1 row)
```

以下は[`object_inspect` Groongaコマンド][object-inspect]用に`pgroonga_index_column_name()`を使う例です。

```sql
SELECT jsonb_pretty(
  pgroonga_command('object_inspect',
                   ARRAY[
                     'name', pgroonga_index_column_name('pgroonga_index', 'tag')
                   ])::jsonb
);
                     jsonb_pretty                     
------------------------------------------------------
--  [                                                   +
--      [                                               +
--          0,                                          +
--          1593478420.606223,                          +
--          0.001304388046264648                        +
--      ],                                              +
--      {                                               +
--          "id": 272,                                  +
--          "name": "index",                            +
--          "type": {                                   +
--              "raw": {                                +
--                  "id": 72,                           +
--                  "name": "column:index"              +
--              },                                      +
--              "name": "index"                         +
--          },                                          +
--          "table": {                                  +
--              "id": 270,                              +
--              "key": {                                +
--                  "type": {                           +
--                      "id": 14,                       +
--                      "name": "ShortText",            +
--                      "size": 4096,                   +
--                      "type": {                       +
--                          "id": 32,                   +
--                          "name": "type"              +
--                      }                               +
--                  },                                  +
--                  "total_size": 0,                    +
--                  "max_total_size": 4294967294        +
--              },                                      +
--              "name": "Lexicon17780_2",               +
--              "type": {                               +
--                  "id": 49,                           +
--                  "name": "table:pat_key"             +
--              },                                      +
--              "value": {                              +
--                  "type": null                        +
--              },                                      +
--              "n_records": 0,                         +
--              "disk_usage": 4243456                   +
--          },                                          +
--          "value": {                                  +
--              "size": "normal",                       +
--              "type": {                               +
--                  "id": 263,                          +
--                  "name": "Sources17780",             +
--                  "size": 4,                          +
--                  "type": {                           +
--                      "id": 48,                       +
--                      "name": "table:hash_key"        +
--                  }                                   +
--              },                                      +
--              "weight": false,                        +
--              "section": false,                       +
--              "position": true,                       +
--              "statistics": {                         +
--                  "max_section_id": 0,                +
--                  "n_array_segments": 0,              +
--                  "n_garbage_chunks": [               +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0                               +
--                  ],                                  +
--                  "total_chunk_size": 0,              +
--                  "n_buffer_segments": 0,             +
--                  "n_garbage_segments": 0,            +
--                  "max_in_use_chunk_id": 0,           +
--                  "max_array_segment_id": 0,          +
--                  "n_unmanaged_segments": 0,          +
--                  "max_buffer_segment_id": 0,         +
--                  "max_n_physical_segments": 131072,  +
--                  "next_physical_segment_id": 0,      +
--                  "max_in_use_physical_segment_id": 0 +
--              }                                       +
--          },                                          +
--          "sources": [                                +
--              {                                       +
--                  "id": 271,                          +
--                  "name": "tag",                      +
--                  "table": {                          +
--                      "id": 263,                      +
--                      "key": {                        +
--                          "type": {                   +
--                              "id": 11,               +
--                              "name": "UInt64",       +
--                              "size": 8,              +
--                              "type": {               +
--                                  "id": 32,           +
--                                  "name": "type"      +
--                              }                       +
--                          },                          +
--                          "total_size": 0,            +
--                          "max_total_size": 4294967295+
--                      },                              +
--                      "name": "Sources17780",         +
--                      "type": {                       +
--                          "id": 48,                   +
--                          "name": "table:hash_key"    +
--                      },                              +
--                      "value": {                      +
--                          "type": null                +
--                      },                              +
--                      "n_records": 0,                 +
--                      "disk_usage": 65536             +
--                  },                                  +
--                  "full_name": "Sources17780.tag"     +
--              }                                       +
--          ],                                          +
--          "full_name": "Lexicon17780_2.index",        +
--          "disk_usage": 565248                        +
--      }                                               +
--  ]
-- (1 row)
```

## 参考

  * [`pgroonga_command`関数][command]

[groonga-object-inspect]:https://groonga.org/ja/docs/reference/commands/object_inspect.html

[command]:pgroonga-command.html
