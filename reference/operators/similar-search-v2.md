---
title: "&~? operator"
upper_level: ../
---

# `&~?` operator

Since 2.0.0.

## Summary

`&~?` operator performs similar search.

## Syntax

```sql
column &~? document
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`document` is a document for similar search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

Similar search searches records that have similar content with `document`. If `document` is short content, similar search may return records that are less similar.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_full_text_search_ops_v2`: For `text`

  * `pgroonga.text_array_full_text_search_ops_v2`: For `text[]`

  * `pgroonga.varchar_full_text_search_ops_v2`: For `varchar`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga.text_full_text_search_ops_v2);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

You can search records that are similar with the specified document by `&~?` operator:

```sql
SELECT * FROM memos WHERE content &~? 'Mroonga is a MySQL extension taht uses Groonga';
--  id |                            content                             
-- ----+----------------------------------------------------------------
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
-- (1 row)
```

## Sequential scan

You can't use similar search with sequential scan. If you use similar search with sequential search, you get the following error:

```sql
SELECT * FROM memos WHERE content &~? 'Mroonga is a MySQL extension taht uses Groonga';
-- ERROR:  pgroonga: operator &~? is available only in index scan
```
