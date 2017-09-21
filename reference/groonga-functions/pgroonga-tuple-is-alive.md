---
title: pgroonga_tuple_is_alive Groonga function
upper_level: ../
---

# `pgroonga_tuple_is_alive` Groonga function

Since 1.1.8.

## Summary

`pgroonga_tuple_is_alive` Groonga function returns whether the tuple associated with the record is alive or not.

PostgreSQL keeps invalid tuples such as `DELETE`-ed or `UPDATE`-ed tuples until `VACUUM`. PostgreSQL removes invalid tuples when it searches.

The Groonga database used by PGroonga also keeps records associated with invalid tuples until `VACUUM`. It means that `SELECT pgroonga_command('select ' || pgroonga_table_name('INDEX_NAME'))` includes records associated with invalid tuples. Because [`select` Groonga command](http://groonga.org/docs/reference/commands/select.html) doesn't know about invalid tuples in PostgreSQL.

`pgroonga_tuple_is_alive` checks whether the tuple associated with the Groonga record is alive (= not invalid). If you add `pgroonga_tuple_is_alive(ctid)` to [`--filter` parameter](http://groonga.org/docs/reference/commands/select.html#select-filter) value of `select` Groonga command, you can get only alive records even if `VACUUM` isn't executed.

## Syntax

Here is the syntax of this Groonga function:

```text
pgroonga_tuple_is_alive(ctid)
```

`ctid` means the `ctid` column. It's automatically created by PGroonga. You shouldn't change it.

## Usage

You need to take care about invalid tuples when you use `select` Groonga command.

You may get invalid records when PGroonga index target table processed one or more `DELETE` or `UPDATE` after the last `VACUUM`. There are records that associated with deleted and/or old tuples in Groonga table for the case. If there are deleted or old tuples, `select` Groonga command may return records associated with them.

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
         pgroonga_command('select ' ||
                          pgroonga_table_name('pgroonga_posts_index')
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
         pgroonga_command('select ' ||
                          pgroonga_table_name('pgroonga_posts_index')
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

You can remove the record associated old tuple by specify `pgroonga_tuple_is_alive(ctid)` as `--filter` parameter value:

```sql
SELECT *
  FROM json_array_elements(
         pgroonga_command('select ' ||
                          pgroonga_table_name('pgroonga_posts_index') ||
                          ' --filter "pgroonga_tuple_is_alive(ctid)"'
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [4,"Mroonga is a MySQL storage engine that uses Groonga as backend.",4,3,"Mroonga"]
-- (5 rows)
```

There isn't the record associated with the old tuple.

The record associated with the old tuple is deleted when `VACUUM` is executed.

Execute `VACUUM FULL` explicitly. And then execute `select` Groonga command without `pgroonga_tuple_is_alive(ctid)` again. It returns 3 records. There isn't the record associated with the old record:

```sql
VACUUM FULL;
SELECT *
  FROM json_array_elements(
         pgroonga_command('select ' ||
                          pgroonga_table_name('pgroonga_posts_index')
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

  * [`pgroonga_command` function][command]

[command]:../functions/pgroonga-command.html
