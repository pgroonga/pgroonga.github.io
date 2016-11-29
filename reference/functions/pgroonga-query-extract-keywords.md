---
title: pgroonga.query_extract_keywords function
---

# `pgroonga.query_extract_keywords` function

Since 1.0.7.

## Summary

`pgroonga.query_extract_keywords` function extract keywords from text that uses [query syntax](http://groonga.org/docs/reference/grn_expr/query_syntax.html). Query syntax is used by [`@@` operator](../operators/query.html), [`&?` operator](../operators/query-v2.html) and so on.

Extracting keywords from query helps you to use [`pgroonga.snippet_html` function](pgroonga-snippet-html.html), [`pgroonga.highlight_html` function](pgroonga-highlight-html.html) and so on. They require keywords as an argument. Normally, the keywords must be keywords in query.

## Syntax

Here is the syntax of this function:

```text
text[] pgroonga.query_extract_keywords(query)
```

`query` is a text that uses [query syntax](http://groonga.org/docs/reference/grn_expr/query_syntax.html).

`pgroonga.query_extract_keywords` returns an array of keywords.

Search terms for AND condition and OR condition are keywords. Search terms for NOT condition aren't keywords. For example, `A`, `B` and `C` are keywords and `D` isn't keyword in `"A (B OR C) - D"`. `-` is NOT operator.

## Usage

You can get all terms as keywords for AND only case:

```sql
SELECT pgroonga.query_extract_keywords('Groonga PostgreSQL');
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

You can get all terms as keywords for OR only case:

```sql
SELECT pgroonga.query_extract_keywords('Groonga OR PostgreSQL');
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

You can use parentheses:

```sql
SELECT pgroonga.query_extract_keywords('Groonga (MySQL OR PostgreSQL)');
--    query_extract_keywords   
-- ----------------------------
--  {Groonga,PostgreSQL,MySQL}
-- (1 row)
```

Term for NOT condition isn't keyword:

```sql
SELECT pgroonga.query_extract_keywords('Groonga - MySQL PostgreSQL');
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

## See also

  * [`pgroonga.snippet_html` function](pgroonga-query-snippet-html.html)

  * [`pgroonga.highlight_html` function](pgroonga-query-highlight-html.html)

  * [`pgroonga.match_positions_byte` function](pgroonga-match-positions-byte.html)
