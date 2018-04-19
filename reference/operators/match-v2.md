---
title: "&@ operator"
upper_level: ../
---

# `&@` operator

Since 1.2.0.

## Summary

`&@` operator performs full text search by one keyword.

## Syntax

There are two signatures:

```sql
column &@ keyword
column &@ ROW(keyword, weights, index_name)
```

The former is simpler than the latter. The former is enough for most cases.

The latter is useful to optimize search score. For example, you can implement "title is more important than content" for blog application.

The latter is available since 2.0.4.

Here is the description of the former signature.

```sql
column &@ keyword
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`keyword` is a keyword for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

Here is the description of the latter signature.

```sql
column &@ ROW(keyword, weights, index_name)
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`keyword` is a keyword for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

`weights` is importance factors of each value. It's `int[]` type. If `column` is `text` type or `varchar` type, the first element is used for importance factor of the value. If `column` is `text[]` type, the same position value is used as importance factor.

`weights` can be `NULL`. Elements of `weights` can also be `NULL`. If the corresponding importance factor is `NULL`, the importance factor is `1`.

If importance factor is `0`, the value is ignored. For example, `ARRAY[1, 0, 1]` means the second value isn't search target.

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.

`index_name` can be `NULL`.

It's for using the same search options specified in PGroonga index in sequential search.

It's not implemented yet.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga_text_full_text_search_ops_v2`: Default for `text`

  * `pgroonga_text_array_full_text_search_ops_v2`: Default for `text[]`

  * `pgroonga_varchar_full_text_search_ops_v2`: For `varchar`

  * `pgroonga_text_full_text_search_ops`: For `text`

  * `pgroonga_text_array_full_text_search_ops`: For `text[]`

  * `pgroonga_varchar_full_text_search_ops`: For `varchar`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

You can perform full text search with one keyword by `&@` operator:

```sql
SELECT * FROM memos WHERE content &@ 'engine';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (1 row)
```

You can also implement "title is more important than content".

Here are sample schema and data for examples:

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING PGroonga ((ARRAY[title, content]));
```

```sql
INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES ('CLI', 'There is groonga command.');
```

You can find more suitable records against "`Groonga`" word with [`pgroonga_score` function][score]:

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@
       ROW('Groonga', ARRAY[5, 1], 'pgroonga_memos_index')
 ORDER BY score DESC;
--   title   |                                content                                 | score 
-- ----------+------------------------------------------------------------------------+-------
--  Groonga  | Groonga is a fast full text search engine that supports all languages. |     6
--  PGroonga | PGroonga is a PostgreSQL extension that uses Groonga as index.         |     1
--  CLI      | There is groonga command.                                              |     1
-- -- (3 rows)
```

You can confirm that the record which has "`Groonga`" in `title` column has more high score than "`Groonga`" in `content` column.

You can ignore `content` column data by specifying `0` as the second weight value:

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@
       ROW('Groonga', ARRAY[5, 0], 'pgroonga_memos_index')
 ORDER BY score DESC;
--   title  |                                content                                 | score 
-- ---------+------------------------------------------------------------------------+-------
--  Groonga | Groonga is a fast full text search engine that supports all languages. |     5
-- (1 row)
```

If you want to perform full text search with multiple keywords or AND/OR search, use [`&@~` operator][query-v2].

If you want to perform full text search with multiple keywords OR search, use [`&@|` operator][match-in-v2].

## See also

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

[query-v2]:query-v2.html
[match-in-v2]:match-in-v2.html

[score]:../functions/pgroonga-score.html
