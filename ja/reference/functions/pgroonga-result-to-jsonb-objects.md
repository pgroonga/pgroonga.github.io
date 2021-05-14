---
title: pgroonga_result_to_jsonb_objects関数
upper_level: ../
---

# `pgroonga_result_to_jsonb_objects`関数

2.3.0で追加。

## 概要

`pgroonga_result_to_jsonb_objects`関数は[`pgroonga_result_to_recordset`関数][pgroonga-result-to-recordset]と似ています

`pgroonga_result_to_jsonb_objects`関数は[`pgroonga_command`関数][pgroonga-command]の結果のJSONをオブジェクトの配列の`jsonb`データに変換します。変換された`jsonb`データはPostgreSQLの[`jsonb_array_elements`関数][postgresql-jsonb-array-elements]を使うと`jsonb`のオブジェクトの集合に変換できます。一般的に、変換語の`jsonb`データのほうが結果のJSONよりも扱いやすいです。

将来的にはGroongaのコマンドのすべての結果JSONフォーマットをサポートする予定ですが、現時点では次のコマンドだけサポートしています。

  * `select`: `command_version=1`

    * ただし、ドリルダウン結果とスライス結果は無視します。

  * `select`: `command_version=3`

    * ただし、ドリルダウン結果とスライス結果は無視します。

## 構文

この関数の構文は次の通りです。

```text
jsonb pgroonga_result_to_jsonb_objects(result)
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

以下は`jsonb`データを返す例です。

```sql
SELECT jsonb_pretty(
  pgroonga_result_to_jsonb_objects(
    pgroonga_command(
      'select',
      ARRAY[
        'table', pgroonga_table_name('pgroonga_memos_index')
      ]
    )::jsonb
  )
);
--                               jsonb_pretty                              
-- ------------------------------------------------------------------------
--  [                                                                     +
--      {                                                                 +
--          "_id": 1,                                                     +
--          "_key": 1,                                                    +
--          "content": "PGroonga (PostgreSQL+Groonga) is great!"          +
--      },                                                                +
--      {                                                                 +
--          "_id": 2,                                                     +
--          "_key": 2,                                                    +
--          "content": "Groonga is an embeddable full text search engine."+
--      }                                                                 +
--  ]
-- (1 row)
```

PostgreSQLの[`jsonb_array_elements`関数][postgresql-jsonb-array-elements]を使うと変換後の`jsonb`データを`josnb`のオブジェクトの集合に変換できます。

```sql
SELECT jsonb_array_elements(
  pgroonga_result_to_jsonb_objects(
    pgroonga_command(
      'select',
      ARRAY[
        'table', pgroonga_table_name('pgroonga_memos_index')
      ]
    )::jsonb
  )
);
--                                  jsonb_array_elements                                  
-- ---------------------------------------------------------------------------------------
--  {"_id": 1, "_key": 1, "content": "PGroonga (PostgreSQL+Groonga) is great!"}
--  {"_id": 2, "_key": 2, "content": "Groonga is an embeddable full text search engine."}
-- (2 rows)
```

## 参考

  * [`pgroonga_result_to_recordset`関数][pgroonga-result-to-recordset]

  * [`pgroonga_command`関数][pgroonga-command]

  * [`pgroonga_table_name`関数][pgroonga-table-name]

[pgroonga-result-to-recordset]:pgroonga-result-to-recordset.html
[pgroonga-command]:pgroonga-command.html
[pgroonga-table-name]:pgroonga-table-name.html

[postgresql-jsonb-array-elements]:{{ site.postgresql_doc_base_url.ja }}/functions-json.html
