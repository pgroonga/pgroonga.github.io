---
title: pgroonga_table_name function
upper_level: ../
---

# `pgroonga_table_name` function

## Summary

`pgroonga_table_name` function converts PGroonga's index name to Groonga's table name. Groonga's table name is useful to use [`select` Groonga command][groonga-select] by [`pgroonga_command` function][command].

You can use weight feature by `select` Groonga command.

## Syntax

Here is the syntax of this function:

```text
text pgroonga_table_name(pgroonga_index_name)
```

`pgroonga_index_name` is a `text` type value. It's an index name to be converted to Groonga's table name. The index must be created with `USING pgroonga`.

`pgroonga_table_name` returns Groonga table name for `pgroonga_index_name` as `text` type value. If `pgroonga_index_name` doesn't exist or isn't a PGroonga index, `pgroonga_table_name` raises an error.

## Usage

Here are sample schema and data. In the schema, both search target data and output data are index target columns:

```sql
CREATE TABLE terms (
  id integer,
  title text,
  content text,
  tag varchar(256)
);

CREATE INDEX pgroonga_terms_index
          ON terms
       USING pgroonga (title, content, tag);

INSERT INTO terms
     VALUES (1,
             'PostgreSQL',
             'PostgreSQL is a relational database management system.',
             'PostgreSQL');
INSERT INTO terms
     VALUES (2,
             'Groonga',
             'Groonga is a fast full text search engine that supports all languages.',
             'Groonga');
INSERT INTO terms
     VALUES (3,
             'PGroonga',
             'PGroonga is a PostgreSQL extension that uses Groonga as index.',
             'PostgreSQL');
```

You can use [`match_columns` option](http://groonga.org/docs/reference/commands/select.html#select-match-columns) to use weight:

```sql
SELECT *
  FROM json_array_elements(
         pgroonga_command('select ' ||
                          pgroonga_table_name('pgroonga_terms_index') || ' ' ||
                          '--match_columns "title * 10 || content" ' ||
                          '--query "Groonga OR PostgreSQL OR engine" ' ||
                          '--output_columns "_score, title, content" ' ||
                          '--sortby "-_score"'
                         )::json->1->0);
--                                           value                                          
-- -----------------------------------------------------------------------------------------
--  [3]
--  [["_score","Int32"],["title","LongText"],["content","LongText"]]
--  [12,"Groonga","Groonga is a fast full text search engine that supports all languages."]
--  [11,"PostgreSQL","PostgreSQL is a relational database management system."]
--  [2,"PGroonga","PGroonga is a PostgreSQL extension that uses Groonga as index."]
-- (5 rows)
```

You can use drilldown feature by [`drilldown` option](http://groonga.org/docs/reference/commands/select.html#select-drilldown):

```sql
SELECT *
  FROM json_array_elements(
         pgroonga_command('select ' ||
                          pgroonga_table_name('pgroonga_terms_index') || ' ' ||
                          '--match_columns "title * 10 || content" ' ||
                          '--query "Groonga OR PostgreSQL OR engine" ' ||
                          '--output_columns "_score, title" ' ||
                          '--sortby "-_score" ' ||
                          '--drilldown "tag"'
                         )::json->1);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [[3],[["_score","Int32"],["title","LongText"]],[12,"Groonga"],[11,"PostgreSQL"],[2,"PGroonga"]]
--  [[2],[["_key","ShortText"],["_nsubrecs","Int32"]],["Groonga",1],["PostgreSQL",2]]
-- (2 rows)
```

`select` Groonga command may help you when `SELECT` statement in SQL is slow.

## See also

  * [`pgroonga_table_name` function description in tutorial][tutorial-pgroonga-table-name]

  * [Attention when you use `select` Groonga command][command-attention]

[groonga-select]:https://groonga.org/docs/reference/commands/select.html

[command]:pgroonga-command.html

[tutorial-pgroonga-table-name]:../../tutorial/#pgroonga-table-name

[command-attention]:pgroonga-command.html#attention
