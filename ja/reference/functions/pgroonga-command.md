---
title: pgroonga.command関数
---

# `pgroonga.command`関数

## 概要

`pgroonga.command`関数は[Groongaのコマンド](http://groonga.org/ja/docs/reference/command.html)を実行して`text`型の値として結果を返します。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.command(command)
text pgroonga.command(name,
                      ARRAY[argument_name1, argument_value1,
                            argument_name2, argument_value2,
                            ...])
```

2つめの構文を推奨します。理由は引数の値を自動でエスケープするからです。これによりシンタックスエラーとGroongaコマンドインジェクションを防げます。

1つめの構文の説明は以下の通りです。

`command`は`text`型の値です。`pgroonga.command`は`command`をGroongaのコマンドとして実行します。

2つめの構文の説明は以下の通りです。

`name`は`text`型の値です。実行するコマンド名です。

`argument_name`は`text`型の値です。引数名です。この後に対応する引数の値が続きます。

`argument_value`は`text`型の値です。直前にした引数名に対応する値です。

`pgroonga.command`は`name`と`argument_name`と`argument_value`からGroongaコマンドを作り、そのGroongaコマンドを実行します。

Groongaのコマンドは結果をJSONとして返します。`pgroonga.command`はJSONを`text`型の値として返します。結果を`json`型か`jsonb`型にキャストすると[PostgreSQLが提供するJSON関数・演算]({{ site.postgresql_doc_base_url.ja }}/functions-json.html)を使うことができます。

## 使い方

サンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content);

INSERT INTO memos VALUES ('PGroonga (PostgreSQL+Groonga) is great!');
```

以下は[`status` Groongaコマンド](http://groonga.org/ja/docs/reference/commands/status.html)の実行例です。このコマンドには引数はありません。

```sql
SELECT jsonb_pretty(pgroonga.command('status')::jsonb);
--               jsonb_pretty               
-- -----------------------------------------
--  [                                      +
--      [                                  +
--          0,                             +
--          1480484730.607103,             +
--          0.0001363754272460938          +
--      ],                                 +
--      {                                  +
--          "uptime": 859,                 +
--          "version": "6.1.0-53-g460b5c9",+
--          "n_queries": 6,                +
--          "starttime": 1480483871,       +
--          "start_time": 1480483871,      +
--          "alloc_count": 14034,          +
--          "cache_hit_rate": 0.0,         +
--          "command_version": 1,          +
--          "max_command_version": 3,      +
--          "default_command_version": 1   +
--      }                                  +
--  ]
-- (1 row)
```

以下は挿入したデータを検索する例です。検索には[`select` Groongaコマンド](http://groonga.org/ja/docs/reference/commands/select.html)を使います。[`pgroonga.table_name`関数](pgroonga-table-name.html)を使ってPGroongaのインデックス名をGroongaのテーブル名に変換する必要があります。

```sql
SELECT jsonb_pretty(
  pgroonga.command(
    'select ' ||
    '--table ' || pgroonga.table_name('pgroonga_memos_index')
  )::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480484984.533947,                                +
--          0.0005786418914794922                             +
--      ],                                                    +
--      [                                                     +
--          [                                                 +
--              [                                             +
--                  1                                         +
--              ],                                            +
--              [                                             +
--                  [                                         +
--                      "_id",                                +
--                      "UInt32"                              +
--                  ],                                        +
--                  [                                         +
--                      "content",                            +
--                      "LongText"                            +
--                  ],                                        +
--                  [                                         +
--                      "ctid",                               +
--                      "UInt64"                              +
--                  ]                                         +
--              ],                                            +
--              [                                             +
--                  1,                                        +
--                  "PGroonga (PostgreSQL+Groonga) is great!",+
--                  1                                         +
--              ]                                             +
--          ]                                                 +
--      ]                                                     +
--  ]
-- (1 row)
```

以下は「PostgreSQL」と「Groonga」を含むレコードを検索する例です。「PostgreSQL Groonga」を1つの引数値として扱うためにダブルクォート（またはシングルクォート）で囲む必要がある点に注意してください。

```sql
SELECT jsonb_pretty(
  pgroonga.command(
    'select ' ||
    '--table ' || pgroonga.table_name('pgroonga_memos_index') || ' ' ||
    '--match_columns content ' ||
    '--query "PostgreSQL Groonga"'
  )::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480485153.923481,                                +
--          0.002448797225952148                              +
--      ],                                                    +
--      [                                                     +
--          [                                                 +
--              [                                             +
--                  1                                         +
--              ],                                            +
--              [                                             +
--                  [                                         +
--                      "_id",                                +
--                      "UInt32"                              +
--                  ],                                        +
--                  [                                         +
--                      "content",                            +
--                      "LongText"                            +
--                  ],                                        +
--                  [                                         +
--                      "ctid",                               +
--                      "UInt64"                              +
--                  ]                                         +
--              ],                                            +
--              [                                             +
--                  1,                                        +
--                  "PGroonga (PostgreSQL+Groonga) is great!",+
--                  1                                         +
--              ]                                             +
--          ]                                                 +
--      ]                                                     +
--  ]
-- (1 row)
```

引数を配列で指定するスタイルと使うと、ダブルクォートで囲むことについて気にする必要がなくなります。

```sql
SELECT jsonb_pretty(
  pgroonga.command(
    'select',
    ARRAY[
      'table', pgroonga.table_name('pgroonga_memos_index'),
      'match_columns', 'content',
      'query', 'PostgreSQL Groonga'
    ]
  )::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480485246.841189,                                +
--          0.00008869171142578125                            +
--      ],                                                    +
--      [                                                     +
--          [                                                 +
--              [                                             +
--                  1                                         +
--              ],                                            +
--              [                                             +
--                  [                                         +
--                      "_id",                                +
--                      "UInt32"                              +
--                  ],                                        +
--                  [                                         +
--                      "content",                            +
--                      "LongText"                            +
--                  ],                                        +
--                  [                                         +
--                      "ctid",                               +
--                      "UInt64"                              +
--                  ]                                         +
--              ],                                            +
--              [                                             +
--                  1,                                        +
--                  "PGroonga (PostgreSQL+Groonga) is great!",+
--                  1                                         +
--              ]                                             +
--          ]                                                 +
--      ]                                                     +
--  ]
-- (1 row)
```

## Groongaの`select`コマンドに関する注意事項 {#attention}

[Groongaの`select`コマンド](http://groonga.org/ja/docs/reference/commands/select.html)を使うとき、不正なタプルについて注意する必要があります。

詳細は[`pgroonga_tuple_is_alive` Groonga関数](../groonga-functions/pgroonga-tuple-is-alive.html)を参照してください。

## 参考

  * [チュートリアルにある例](../../tutorial/#groonga)

  * [`pgroonga.table_name`関数](pgroonga-table-name.html)

  * [`pgroonga_tuple_is_alive` Groonga関数](../groonga-functions/pgroonga-tuple-is-alive.html)
