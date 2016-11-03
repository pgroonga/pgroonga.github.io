---
title: pgroonga.command function
---

# `pgroonga.command` function

## Summary

`pgroonga.command` function executes a [Groonga command](http://groonga.org/docs/reference/command.html) and returns the result as `text` type value.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.command(command)
```

`command` is a `text` type value. `pgroonga.command` executes `command` as a Groonga command.

Groonga command returns result as JSON. `pgroonga.command` returns the JSON as `text` type value. You can use [JSON functions and operations provided by PostgreSQL](https://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/functions-json.html) by casting the result to `json` or `jsonb` type.

## Usage

See [examples in tutorial](../../tutorial/#groonga).

## Attention for `select` Groonga command {#attention}

You need to take care about invalid records when you use [`select` Groonga command](http://groonga.org/docs/reference/commands/select.html).

You may get invalid records when PGroonga index target table processed one or more `DELETE` or `UPDATE` after last `VACUUM`. There are deleted and/or old records exist in Groonga table for the case. If there are deleted or old records, `select` Groonga command may return them.

The followings show this case by example.

Here are sample schema and data for examples:

```sql
CREATE TABLE posts (
  id integer PRIMARY KEY,
  title text,
  content text
);

CREATE INDEX pgroonga_posts_index
          ON posts
       USING pgroonga (id, title, content);

INSERT INTO posts VALUES (1, 'PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO posts VALUES (2, 'Groonga', 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO posts VALUES (3, 'PGroonga', 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
```

Here is the result before updating. There are 3 records:

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_posts_index')
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [3,"PGroonga is a PostgreSQL extension that uses Groonga as index.",3,3,"PGroonga"]
-- (5 rows)
```

Update 1 record:

```sql
UPDATE posts
   SET title = 'Mroonga',
       content = 'Mroonga is a MySQL storage engine that uses Groonga as backend.'
 WHERE id = 3;
```

Executes `select` Groonga command again. It returns 4 records. 1 record is added because there is the record before updating:

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_posts_index')
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [4]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [3,"PGroonga is a PostgreSQL extension that uses Groonga as index.",3,3,"PGroonga"]
--  [4,"Mroonga is a MySQL storage engine that uses Groonga as backend.",4,3,"Mroonga"]
-- (6 rows)
```

The old record is deleted when `VACUUM` is executed.

Execute `VACUUM FULL` explicitly. And then execute `select` Groonga command again. It returns 3 records. There isn't the old record:

```sql
VACUUM FULL;
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_posts_index')
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [3,"Mroonga is a MySQL storage engine that uses Groonga as backend.",3,3,"Mroonga"]
-- (5 rows)
```

## See also

  * [Examples in tutorial](../../tutorial/#groonga)
