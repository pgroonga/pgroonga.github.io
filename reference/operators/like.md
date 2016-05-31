---
title: LIKE operator
---

# `LIKE` operator

## Summary

PGroonga converts `column LIKE '%KEYWORD%'` condition to `column %% 'KEYWORD'` internally. [`%%` operator](match.html) performs full text search with index. It's faster than `LIKE` operator without index.

`column LIKE '%KEYWORD%'` with index is slower than `column %% 'KEYWORD'` with index because `column LIKE '%KEYWORD%'` with index needs "[Recheck](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/index-scanning.html)". `column %% 'KEYWORD'` doesn't need "Recheck".

The original `LIKE` operator searches against text as is. But `%%` operator performs full text search against normalized text. It means that search result of `LIKE` operator with index needs "Recheck".


## Syntax

Here is the syntax of this operator:

```sql
column LIKE pattern
```

`column` is a column to be searched.

`pattern` is a search pattern. It's `text` type.

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

You can perform `LIKE` operator with index:

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |          content          
-- ----+---------------------------
--   4 | There is groonga command.
-- (1 row)
```

The default operator class of PGroonga index for `text` type can't find any records with partial alphabet keyword. For example, you can't find record with `roonga` keyword:

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id | content 
-- ----+---------
-- (0 rows)
```

But you can find some records with `roonga` keyword without index:

```sql
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   4 | There is groonga command.
-- (3 rows)
```

You can find records by prefix alphabet keyword such as `Gro`:

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%Gro%';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
-- (2 rows)
```

If you want to search by partial alphabet keyword, there are two approaches.

The first approach is using the `TokenBigramSplitSymbolAlphaDigit` tokenizer:

```sql
DROP INDEX IF EXISTS pgroonga_content_index;

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenBigramSplitSymbolAlphaDigit');
```

You can find records by `roonga`:

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   4 | There is groonga command.
-- (3 rows)
```

See [Customization in `CREATE INDEX USING pgroonga`](../create-index-using-pgroonga.html#customization) for tokenizer.

The second approach is using `pgroonga.text_regexp_ops` operator class:

```sql
DROP INDEX IF EXISTS pgroonga_content_index;

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content pgroonga.text_regexp_ops);
```

You can find records by `rooonga`:

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   4 | There is groonga command.
-- (3 rows)
```

## See also

  * [`CREATE INDEX USING pgroonga`](../create-index-using-pgroonga.html)

