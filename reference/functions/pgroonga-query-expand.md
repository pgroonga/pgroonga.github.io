---
title: pgroonga_query_expand function
upper_level: ../
---

# `pgroonga_query_expand` function

Since 1.2.2.

## Summary

`pgroonga_query_expand` function expands registered synonyms in query in [query syntax][groonga-query-syntax]. Query syntax is used by [`&@~` operator][query-v2], [`&@~|` operator][query-in-v2] and so on.

`pgroonga_query_expand` function is useful to implement [query expansion][wikipedia-query-expansion]. See also [document for Groonga's query expansion feature][groonga-query-expander].

## Syntax

Here is the syntax of this function:

```text
text pgroonga_query_expand(table_name,
                           term_column_name,
                           synonyms_column_name,
                           query)
```

`table_name` is a `text` type value. It's an existing table name that stores synonyms.

`term_column_name` is a `text` type value. It's an column name that stores term to be expanded in the `table_name` table. The column is `text` type value.

`synonyms_column_name` is a `text` type value. It's an column name that stores synonyms of the `term` column. The column is `text[]` type value.

`query` is a `text` type value. It's a query that uses [query syntax][groonga-query-syntax].

`pgroonga_query_expand` returns a `text` type value. All registered synonyms are expanded in the `query`.

It's recommended that `${table_name}.${term_column_name}` is indexed by PGroonga with `pgroonga_text_term_search_ops_v2` operator class for fast query expansion like the following:

```sql
CREATE TABLE synonyms (
  term text,
  synonyms text[]
);

CREATE INDEX synonyms_term
          ON synonyms
       USING pgroonga (term pgroonga_text_term_search_ops_v2);
```

`pgroonga_query_escape` function can work without index but can work faster with index.

You can use all index access methods that support `=` for `text` type such as `btree`. But it's recommended that you use PGroonga. Because PGroonga supports value normalized `=` (including case insensitive comparison) for `text`. Value normalized `=` is useful for query expansion.

## Usage

Here are sample schema and data:

```sql
CREATE TABLE synonyms (
  term text,
  synonyms text[]
);

CREATE INDEX synonyms_term
          ON synonyms
       USING pgroonga (term pgroonga_text_term_search_ops_v2);

INSERT INTO synonyms VALUES ('PGroonga', ARRAY['PGroonga', 'Groonga PostgreSQL']);
```

In this sample, all of `"PGroonga"` and `"pgroonga"` in query are expanded because PGroonga index is used:

```sql
SELECT pgroonga_query_expand('synonyms', 'term', 'synonyms',
                             'PGroonga OR Mroonga') AS query_expand;
--                  query_expand                   
-- -------------------------------------------------
--  ((PGroonga) OR (Groonga PostgreSQL)) OR Mroonga
-- (1 row)
SELECT pgroonga_query_expand('synonyms', 'term', 'synonyms',
                             'pgroonga OR mroonga') AS query_expand;
--                   query_expand                   
-- -------------------------------------------------
--  ((PGroonga) OR (Groonga PostgreSQL)) OR mroonga
-- (1 row)
```

## See also

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&@~|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html

[groonga-query-expander]:http://groonga.org/docs/reference/commands/select.html#select-query-expander

[wikipedia-query-expansion]:https://en.wikipedia.org/wiki/Query_expansion

[query-v2]:../operators/query-v2.html

[query-in-v2]:../operators/query-in-v2.html
