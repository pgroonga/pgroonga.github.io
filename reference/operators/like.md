---
title: LIKE operator
layout: en
---

# `LIKE` operator

PGroonga converts `column LIKE '%KEYWORD%'` condition to `column %% 'KEYWORD'` internally. [`%%` operator](match.html) does full text search with index. It's fast rather than `LIKE` operator without index.

Both beginning `%` and ending `%` are important. `'KEYWORD%'`, `'%KEYWORD'` and so on aren't converted to `column %% 'KEYWORD'`. PGroonga returns no records for these patterns. Because PGroonga can't search these patterns with index.

The original `LIKE` operator searches against text as is. But `%%` operator does full text search against normalized text. It means that search result of `LIKE` operator with index and search result of the original `LIKE` operator may be different.

For example, the original `LIKE` operator searches with case sensitive. But `LIKE` operator with index searches with case insensitive.

A search result of the original `LIKE` operator:

```sql
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;
SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |           content           
-- ----+-----------------------------
--   4 | groongaコマンドがあります。
-- (1 行)
```

A search result of `LIKE` operator with index:

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;
SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   4 | groongaコマンドがあります。
-- (3 行)
```

If you want to get the same result by both `LIKE` operator with index and the original `LIKE` operator, use the following tokenizer and normalizer:

  * Tokenizer: `TokenBigramSplitSymbolAlphaDigit`
  * Normalizer: None

Here is a concrete example:

```sql
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
--  id |           content           
-- ----+-----------------------------
--   4 | groongaコマンドがあります。
-- (1 行)
```

Normally, the default configuration returns better result for full text search rather than the original `LIKE` operator. Think about which result is better for users before you change the default configuration.

See [Customization in `CREATE INDEX USING pgroonga`](../create-index-using-pgroonga.html#customization) for tokenizer and normalizer.
