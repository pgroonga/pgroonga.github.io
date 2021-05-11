---
title: pgroonga_result_to_recordset関数
upper_level: ../
---

# `pgroonga_result_to_recordset`関数

2.3.0で追加。

## 概要

`pgroonga_result_to_recordset`関数は[`pgroonga_command`関数][pgroonga-command]の結果のJSONを`record`型の集合に変換します。この関数はPostgreSQLの[`jsonb_to_recordset`関数][postgresql-jsonb-to-recordset]に似ています。通常、`record`型の集合の方がJSONデータよりも扱いやすいです。

将来的にはGroongaのコマンドのすべての結果JSONフォーマットをサポートする予定ですが、現時点では次のコマンドだけサポートしています。

  * `select`: `command_version=1`

    * ただし、ドリルダウン結果とスライス結果は無視します。

  * `select`: `command_version=3`

    * ただし、ドリルダウン結果とスライス結果は無視します。

## 構文

この関数の構文は次の通りです。

```text
setof record pgroonga_result_to_recordset(result)
```

`result`は`jsonb`型の値です。`pgroonga_command`関数の結果の`text`を`jsonb`にキャストすればこの関数に渡せます。

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
INSERT INTO memos VALUES ('Groonga is an embeddable full text search engine.');
```

以下は`record`の集合を返す例です。

```sql
SELECT pgroonga_result_to_recordset(
  pgroonga_command(
    'select',
    ARRAY[
      'table', pgroonga_table_name('pgroonga_memos_index')
    ]
  )::jsonb
);
--                pgroonga_result_to_recordset                
-- -----------------------------------------------------------
--  (1,1,"PGroonga (PostgreSQL+Groonga) is great!")
--  (2,2,"Groonga is an embeddable full text search engine.")
-- (2 rows)
```

カラム名とカラムの型を`AS`で指定することで`FROM`でこの結果レコードの集合を使うことができます。

```sql
SELECT *
  FROM pgroonga_result_to_recordset(
         pgroonga_command(
           'select',
           ARRAY[
             'table', pgroonga_table_name('pgroonga_memos_index')
           ]
         )::jsonb
       ) AS record(
         _id bigint,
         _key bigint,
         content text
       );
--  _id | _key |                      content                      
-- -----+------+---------------------------------------------------
--    1 |    1 | PGroonga (PostgreSQL+Groonga) is great!
--    2 |    2 | Groonga is an embeddable full text search engine.
-- (2 rows)
```

## 参考

 * [`pgroonga_command`関数][pgroonga-command]

 * [`pgroonga_table_name`関数][pgroonga-table-name]

[pgroonga-command]:pgroonga-command.html
[pgroonga-table-name]:pgroonga-table-name.html

[postgresql-jsonb-to-recordset]:{{ site.postgresql_doc_base_url.ja }}/functions-json.html
