---
title: LIKE operator
layout: en
---

# `LIKE` operator

## Summary

PGroonga converts `column LIKE '%KEYWORD%'` condition to `column %% 'KEYWORD'` internally. [`%%` operator](match.html) does full text search with index. It's fast rather than `LIKE` operator without index.

## Syntax

Here is the syntax of this operator:

```sql
column LIKE pattern
```

`column` is a column to be searched.

`pattern` is a search pattern. It's `text` type. It must be `'%KEYWORD%'` format.

Both beginning `%` and ending `%` are important. `'KEYWORD%'`, `'%KEYWORD'` and so on aren't converted to `column %% 'KEYWORD'`. PGroonga returns no records for these patterns. Because PGroonga can't search these patterns with index.

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

The original `LIKE` operator searches against text as is. But `%%` operator does full text search against normalized text. It means that search result of `LIKE` operator with index and search result of the original `LIKE` operator may be different.

For example, the original `LIKE` operator searches with case sensitive. But `LIKE` operator with index searches with case insensitive.

A search result of the original `LIKE` operator:

```sql
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |          content          
-- ----+---------------------------
--   4 | There is groonga command.
-- (1 row)
```

A search result of `LIKE` operator with index:

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   4 | There is groonga command.
-- (3 rows)
```

If you want to get the same result by both `LIKE` operator with index and the original `LIKE` operator, use the following tokenizer and normalizer:

  * Tokenizer: `TokenBigramSplitSymbolAlphaDigit`
  * Normalizer: None

Here is a concrete example:

```sql
DROP INDEX IF EXISTS pgroonga_content_index;

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenBigramSplitSymbolAlphaDigit',
              normalizer='');
```

You can get the same result as the original `LIKE` operator with `LIKE` operator with index:

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

Normally, the default configuration returns better result for full text search rather than the original `LIKE` operator. Think about which result is better for users before you change the default configuration.

See [Customization in `CREATE INDEX USING pgroonga`](../create-index-using-pgroonga.html#customization) for tokenizer and normalizer.
