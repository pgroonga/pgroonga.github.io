---
title: "<&@*> operator"
upper_level: ../
---

# `<&@*>` operator

Since 4.0.5.

This is still an experimental feature.

## Summary

`<&@*>` operator calculates the distance between texts.

You can determine that texts are semantically closer when the value is smaller.

## Syntax

```sql
column <&@*> pgroonga_condition(query)
```

`column` is a column to be searched. It's `text` type.

`query` is a query that calculates distance. It's `text` type.

Use [`pgroonga_condition` function][condition].

[`pgroonga_condition` function][condition] accepts some arguments, but please use it by specifying only `query`.

## Operator classes

You need to specify the `pgroonga_text_semantic_search_ops_v2` operator class to use this operator.

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

INSERT INTO memos VALUES (1, 'PostgreSQL is a RDBMS.');
INSERT INTO memos VALUES (2, 'Groonga is fast full text search engine.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga.');
```

Here is how the index is created.
For details on creating an index, see [`CREATE INDEX USING pgroonga`][create-index].

```sql
CREATE INDEX pgroonga_index ON memos
 USING pgroonga (content pgroonga_text_semantic_search_ops_v2)
 WITH (plugins = 'language_model/knn',
       model = 'hf:///groonga/all-MiniLM-L6-v2-Q4_K_M-GGUF');
```

You can use `<&@*>` operator in `ORDER BY` to sort in order of distance.

```sql
SELECT id, content
  FROM memos
 ORDER BY content <&@*> pgroonga_condition('What is a MySQL alternative?');
--  id |                        content                        
-- ----+-------------------------------------------------------
--   1 | PostgreSQL is a RDBMS.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga.
--   2 | Groonga is fast full text search engine.
-- (3 rows)
```

## See also

* [`CREATE INDEX USING pgroonga`][create-index]

* [`&@*` operator][semantic-search-v2]: Semantic search

* [`pgroonga_condition` function][condition]

[semantic-search-v2]:semantic-search-v2.html

[create-index]:../create-index-using-pgroonga.html#semantic-search

[condition]:../functions/pgroonga-condition.html
