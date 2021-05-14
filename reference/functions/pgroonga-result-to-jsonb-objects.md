---
title: pgroonga_result_to_jsonb_objects function
upper_level: ../
---

# `pgroonga_result_to_jsonb_objects` function

Since 2.3.0.

## Summary

`pgroonga_result_to_jsonb_objects` function is similar to [`pgroonga_result_to_recordset` function][pgroonga-result-to-recordset].

`pgroonga_result_to_jsonb_objects` function converts [`pgroonga_command` function][pgroonga-command]'s result JSON to a `jsonb` data that is an array of objects. You can convert the converted `jsonb` data to set of `jsonb` objects by PostgreSQL's [`jsonb_array_elements` function][postgresql-jsonb-array-elements]. Generally, the converted `jsonb` data is is easier to handle rather than result JSON.

This will support all result JSON formats of Groonga command but the following commands are only supported for now:

  * `select`: `command_version=1`

    * But drilldown results and slice results are ignored.

  * `select`: `command_version=3`

    * But drilldown results and slice results are ignored.

## Syntax

Here is the syntax of this function:

```text
jsonb pgroonga_result_to_jsonb_objects(result)
```

`result` is a `jsonb` type value. You can cast `pgroonga_command` function's result `text` to `jsonb` to pass it to this function.

## Usage

Here are sample schema and data:

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

Here is an example to return `jsonb` data:

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

You can use PostgreSQL's [`jsonb_array_elements` function][postgresql-jsonb-array-elements] to convert the converted `jsonb` data to set of `jsonb` objects:

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

## See also

  * [`pgroonga_result_to_recordset` function][pgroonga-result-to-recordset]

  * [`pgroonga_command` function][pgroonga-command]

  * [`pgroonga_table_name` function][pgroonga-table-name]

[pgroonga-result-to-recordset]:pgroonga-result-to-recordset.html
[pgroonga-command]:pgroonga-command.html
[pgroonga-table-name]:pgroonga-table-name.html

[postgresql-jsonb-array-elements]:{{ site.postgresql_doc_base_url.en }}/functions-json.html
