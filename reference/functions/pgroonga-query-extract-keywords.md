---
title: pgroonga_query_extract_keywords function
upper_level: ../
---

# `pgroonga_query_extract_keywords` function

Since 1.0.7.

## Summary

`pgroonga_query_extract_keywords` function extract keywords from text that uses [query syntax](http://groonga.org/docs/reference/grn_expr/query_syntax.html). Query syntax is used by [`&@~` operator][query-v2], [`&@~|` operator][query-in-v2] and so on.

Extracting keywords from query helps you to use [`pgroonga_snippet_html` function](pgroonga-snippet-html.html), [`pgroonga_highlight_html` function](pgroonga-highlight-html.html) and so on. They require keywords as an argument. Normally, the keywords must be keywords in query.

## Syntax

Here is the syntax of this function:

```text
text[] pgroonga_query_extract_keywords(query, index_name DEFAULTS '')
```

`query` is a `text` type value. It uses [query syntax](http://groonga.org/docs/reference/grn_expr/query_syntax.html).

`index_name` is a `text` type value. If you're using `query_allow_column=true` option with your index, you need to specify the index name.

`index_name` is available since 3.0.0.

`pgroonga_query_extract_keywords` returns an array of keywords.

Search terms for AND condition and OR condition are keywords. Search terms for NOT condition aren't keywords. For example, `A`, `B` and `C` are keywords and `D` isn't keyword in `"A (B OR C) - D"`. `-` is NOT operator.

## Usage

You can get all terms as keywords for AND only case:

```sql
SELECT pgroonga_query_extract_keywords('Groonga PostgreSQL') AS query_extract_keywords;
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

You can get all terms as keywords for OR only case:

```sql
SELECT pgroonga_query_extract_keywords('Groonga OR PostgreSQL') AS query_extract_keywords;
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

You can use parentheses:

```sql
SELECT pgroonga_query_extract_keywords('Groonga (MySQL OR PostgreSQL)') AS query_extract_keywords;
--    query_extract_keywords   
-- ----------------------------
--  {Groonga,PostgreSQL,MySQL}
-- (1 row)
```

Term for NOT condition isn't keyword:

```sql
SELECT pgroonga_query_extract_keywords('Groonga - MySQL PostgreSQL') AS query_extract_keywords;
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

You need to specify `index_name` when you use `query_allow_column=true`:

```sql
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memo_texts_index
          ON memos
       USING pgroonga (title, content)
        WITH (query_allow_column=true);

SELECT pgroonga_query_extract_keywords(
         'Groonga content:@PostgreSQL',
         index_name => 'pgroonga_memo_texts_index') AS keywords;
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

## See also

  * [`pgroonga_snippet_html` function][snippet-html]

  * [`pgroonga_highlight_html` function][highlight-html]

  * [`pgroonga_match_positions_byte` function][match-positions-byte]

[query-v2]:../operators/query-v2.html

[query-in-v2]:../operators/query-in-v2.html

[snippet-html]:pgroonga-query-snippet-html.html
[highlight-html]:pgroonga-highlight-html.html
[match-positions-byte]:pgroonga-match-positions-byte.html
