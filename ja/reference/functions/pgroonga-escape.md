---
title: pgroonga.escape関数
---

# `pgroonga.escape`関数

1.1.9で追加。

## 概要

`pgroonga.escape`関数は渡された値を[スクリプト構文](http://groonga.org/ja/docs/reference/grn_expr/script_syntax.html)のリテラルに変換します。このリテラルはスクリプト構文内で安全に使えます。スクリプト構文は[JSONBの`@@`演算子](../operators/jsonb-query.html)などで使っています。

`pgroonga.escape`関数は[`pgroonga.command`関数](pgroonga-command.html)経由でのGroongaコマンドインジェクションが発生することを防ぐために使えます。Groongaコマンドインジェクションを防ぐことについては[`pgroonga.command_escape_value`関数](pgroonga-command-escape-value.html)と[`pgroonga.query_escape`関数](pgroonga-query-escape.html)も見てください。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.escape(value)
```

`value`の型は次のどれかです。

  * `text`

  * `boolean`

  * `int2`

  * `int4`

  * `int8`

  * `float4`

  * `float8`

  * `timestamp`

  * `timestamptz`

`value`は[スクリプト構文](http://groonga.org/ja/docs/reference/grn_expr/script_syntax.html)で使うリテラルです。

`pgroonga.query_escape`は`text`型の値を返します。この値はスクリプト構文中でリテラルとして安全に使えます。

もし`value`が`text`型の値の場合は、次のようにエスケープ対象の文字を0個以上指定できます。

```text
text pgroonga.escape(value, special_characters)
```

`special_characters`は`text`型の値です。この値にエスケープ対象の文字をすべて含めます。「(」と「)」をエスケープしたい場合は`'()'`と指定します。

## 使い方

サンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE logs (
  message jsonb
);

CREATE INDEX pgroonga_logs_index
          ON logs
       USING pgroonga (message);

INSERT INTO logs VALUES ('{"body": "\"index.html\" not found"}');
```

`"index.html" not found`を検索したい場合は、次のように`"`を`\"`とエスケープします。

```sql
SELECT * FROM logs
 WHERE message @@ 'string @ "\"index.html\" not found"';
--                message                
-- --------------------------------------
--  {"body": "\"index.html\" not found"}
-- (1 row)
```

この用途に`pgroonga.escape`関数を使えます。

```sql
SELECT * FROM logs
 WHERE message @@ ('string @ ' || pgroonga.escape('"index.html" not found'));
--                message                
-- --------------------------------------
--  {"body": "\"index.html\" not found"}
-- (1 row)
```

`pgroonga.escape`関数は[`pgroonga.command`関数](pgroonga-command.html)と組み合わせたときも便利です。

```sql
SELECT jsonb_pretty(
  pgroonga.command('select',
                   ARRAY[
                     'table', pgroonga.table_name('pgroonga_logs_index'),
                     'output_columns', 'message.string',
                     'filter', 'message.string @ ' || pgroonga.escape('"index.html" not found')
                   ])::jsonb
);
--                   jsonb_pretty                  
-- ------------------------------------------------
--  [                                             +
--      [                                         +
--          0,                                    +
--          1480435379.074671,                    +
--          0.0004425048828125                    +
--      ],                                        +
--      [                                         +
--          [                                     +
--              [                                 +
--                  1                             +
--              ],                                +
--              [                                 +
--                  [                             +
--                      "message.string",         +
--                      "LongText"                +
--                  ]                             +
--              ],                                +
--              [                                 +
--                  [                             +
--                      "",                       +
--                      "\"index.html\" not found"+
--                  ]                             +
--              ]                                 +
--          ]                                     +
--      ]                                         +
--  ]
-- (1 row)
```

数値のように`text`型以外の値にも`pgroonga.escape`関数を使えます。

```sql
SELECT jsonb_pretty(
  pgroonga.command('select',
                   ARRAY[
                     'table', pgroonga.table_name('pgroonga_logs_index'),
                     'output_columns', '_id',
                     'filter', '_id == ' || pgroonga.escape(1)
                   ])::jsonb
);
--           jsonb_pretty          
-- --------------------------------
--  [                             +
--      [                         +
--          0,                    +
--          1480435504.153011,    +
--          0.00009799003601074219+
--      ],                        +
--      [                         +
--          [                     +
--              [                 +
--                  1             +
--              ],                +
--              [                 +
--                  [             +
--                      "_id",    +
--                      "UInt32"  +
--                  ]             +
--              ],                +
--              [                 +
--                  1             +
--              ]                 +
--          ]                     +
--      ]                         +
--  ]
-- (1 row)
```

## 参考

  * [`pgroonga.command`関数](pgroonga-command.html)

  * [`pgroonga.command_escape_value`関数](pgroonga-command-escape-value.html)

  * [`pgroonga.query_escape`関数](pgroonga-query-escape.html)
