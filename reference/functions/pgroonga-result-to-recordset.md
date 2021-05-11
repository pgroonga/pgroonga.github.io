---
title: pgroonga_result_to_recordset function
upper_level: ../
---

# `pgroonga_result_to_recordset` function

Since 2.3.0.

## Summary

`pgroonga_result_to_recordset` function converts [`pgroonga_command` function][pgroonga-command]'s result JSON to set of `record` type. This is similar to PostgreSQL's [`jsonb_to_recordset` function][postgresql-jsonb-to-recordset]. Generally, set of `record` type is easier to handle rather than JSON data.

This will support all result JSON formats of Groonga command but the following commands are only supported for now:

  * `select`: `command_version=1`

    * But drilldown results and slice results are ignored.

  * `select`: `command_version=3`

    * But drilldown results and slice results are ignored.

## Syntax

Here is the syntax of this function:

```text
setof record pgroonga_result_to_recordset(result)
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

Here is an example to return set of `record`:

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

You can use the result record set for `FROM` by specifying column names and types by `AS`:

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

## See also

 * [`pgroonga_command` function][pgroonga-command]

 * [`pgroonga_table_name` function][pgroonga-table-name]

[pgroonga-command]:pgroonga-command.html
[pgroonga-table-name]:pgroonga-table-name.html

[postgresql-jsonb-to-recordset]:{{ site.postgresql_doc_base_url.en }}/functions-json.html
