---
title: pgroonga.command_escape_value関数
---

# `pgroonga.command_escape_value`関数

1.1.9で追加。

## 概要

`pgroonga.command_escape_value`関数はGroongaコマンドのフォーマットのうち「値」部分の特別な文字をエスケープします。

以下はGroongaコマンドのフォーマット例です。

```text
select --table Logs --match_columns message --query Error
```

`select`はコマンド名です。`--XXX YYY`は引数の名前と値です。`XXX`は引数名です。`YYY`は引数値です。たとえば、`--table Logs`では`table`が引数名で`Logs`が引数値です。

`pgroonga.command_escape_value`関数は[`pgroonga.command`関数](pgroonga-command.html)経由でのGroongaコマンドインジェクションを防ぐために使えます。Groongaコマンドインジェクションを防ぐことについては[`pgroonga.query_escape`関数](pgroonga-query-escape.html)と[`pgroonga.escape`関数](pgroonga-escape.html)も見てください。

`pgroonga.command(command, ARRAY[arguments...])`スタイルを使っている場合はこの関数を使う必要はありません。なぜなら、このスタイルではこの関数がやることと同じことを内部でやってくれるからです。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.command_escape_value(value)
```

`value`は`text`型の値です。Groongaコマンドのフォーマットの「値」部分を指定します。

`pgroonga.command_escape_value`は`text`型の値を返します。この値中の特別な意味を持つ文字はすべてエスケープされています。

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

クエリーが「(PostgreSQL」の場合はエラーが発生します。なぜなら「(」が特別な文字だからです。

```sql
SELECT jsonb_pretty(
  pgroonga.command('select ' ||
                   '--table ' || pgroonga.table_name('pgroonga_memos_index') || ' ' ||
                   '--match_columns content ' ||
                   '--query (PostgreSQL')::jsonb
);
--                      jsonb_pretty                      
-- -------------------------------------------------------
--  [                                                    +
--      [                                                +
--          -22,                                         +
--          1480483949.578879,                           +
--          0.0002233982086181641,                       +
--          "[select][table] invalid name: <PostgreSQL>",+
--          [                                            +
--              [                                        +
--                  "grn_select",                        +
--                  "proc_select.c",                     +
--                  2973                                 +
--              ]                                        +
--          ]                                            +
--      ]                                                +
--  ]
-- (1 row)
```

`pgroonga.command_escape_value`関数を[`pgroonga.query_escape`関数](pgroonga-qurey-escape.html)と一緒に使うとこのケースを防げます。

```sql
SELECT jsonb_pretty(
  pgroonga.command('select ' ||
                   '--table ' || pgroonga.table_name('pgroonga_memos_index') || ' ' ||
                   '--match_columns content ' ||
                   '--query ' || pgroonga.command_escape_value(pgroonga.query_escape('(PostgreSQL')))::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480432832.061276,                                +
--          0.0252687931060791                                +
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

コマンドの引数を配列で指定するスタイルで[`pgroonga.command`関数](pgroonga-command.html)使ってもこのケースを防ぐことができます。

```sql
SELECT jsonb_pretty(
  pgroonga.command('select',
                   ARRAY[
                     'table', pgroonga.table_name('pgroonga_memos_index'),
                     'match_columns', 'content',
                     'query', pgroonga.query_escape('(PostgreSQL')
                   ])::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480433038.482539,                                +
--          0.0001201629638671875                             +
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

## 参考

  * [`pgroonga.command`関数](pgroonga-command.html)

  * [`pgroonga.query_escape`関数](pgroonga-query-escape.html)

  * [`pgroonga.escape`関数](pgroonga-escape.html)
