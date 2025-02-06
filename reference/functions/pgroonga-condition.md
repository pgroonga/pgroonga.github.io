---
title: pgroonga_condition function
upper_level: ../
---

# `pgroonga_condition()` function

Since 3.1.6.

## Summary

`pgroonga_condition()` function returns `pgroonga_condition` type value.
The function and the type have same name, but they are two different things.
`pgroonga_condition` type represents complicated conditional expressions, such as `pgroonga_full_text_search_condition` type and `pgroonga_full_text_search_condition_with_scorers` type.

`pgroonga_condition()` function is a useful function to make the `pgroonga_condition` type value.
It allows to make the `pgroonga_condition` type value by designating the specific attribute values.

There were not this kind of useful functions for `pgroonga_full_text_search_condition` type and `pgroonga_full_text_search_condition_with_scorers` type, so designating all attribute values was necessary to make the value.

Therefore, you need to designate `NULL` for disused attribute value as follows when `pgroonga_full_text_search_condition` type and `pgroonga_full_text_search_condition_with_scorers` type are used to avoid making all the values.

```sql
title &@~ ('keyword', NULL, 'index_name')::pgroonga_full_text_search_condition
title &@~ ('keyword', ARRAY[1,1,1,5,0], NULL, 'index_name')::pgroonga_full_text_search_condition_with_scorers
```

It was not possible for existing value creation methods to make new attribute value while keeping backward compatibility.
Thus, it was necessary to add a new type every time when a new attribute value is added, such as `pgroonga_full_text_search_condition_with_XXX` type.
For example, `pgroogna_full_text_search_condition_with_scorers` type was added because of the added new attribute.

The difference between `pgroonga_full_text_search_condition` type and `pgroonga_full_text_search_condition_with_scorers` type is whether `scorers` exist or not. If `scorers` is added to `pgroonga_full_text_search_condition` type, every users are required to insert new `NULL` to make `pgroonga_full_text_search_condition` type regardless of `scorers` usage.

However, installing `pgroonga_condition()` function to make new `pgroonga_condition` type value let a new attribute to be added while keeping backward compatibility.
It is because `pgroonga_condition()` function absorbs incompatibility.

`pgroonga_condition()` function lets current writing style when a new attribute value is added because the function can leave out unnecessary attribute value as following sample.
(In the following sample, `weights`, `scorers`, `schema_name` and `column_name` are left out. The details of attribute values would be noted in next ["Syntax"](#syntax). Here, point is that possibility of leaving out unnecessary attribute values.)

```sql
title &@~ pgroonga_condition('keyword', index_name => 'index_name')
```

Please note that while using `pgroonga_condition()` function you can leave out attribute values instead you need to describe comment like keyword argument such as `index_name => 'index name'`.

In the above sample, there are mix of attribute values which is like keyword argument or not.
How to separate writing is going to be explained in next ["Syntax"](#syntax).
The point here is there is need of different writing from the current.

## Syntax

Here is the syntax of this function:

```
pgroonga_condition pgroonga_condition(keyword,
                                      weights,
                                      scorers,
                                      schema_name,
                                      index_name,
                                      column_name,
                                      fuzzy_max_distance_ratio)
```

`keyword` is a keyword for full text search. It's `text` type.

`weights` is importance factors of each value. It's `int[]` type.

`scorers` is [score compute procedures][scorer] of each value. It's `text[]` type.

`schema_name` is the schema name to which the index that PGroonga refers to when executing a sequential search belongs. It's `text` type.

`index_name` is index name which PGroonga refer to when executing sequential search. It's `text` type.

`column_name` is the column name within the index which PGroonga refers to when executing a sequential search. It's `text` type.

`fuzzy_max_distance_ratio` is the ratio of the edit distance. It's `float4` type. (Since 3.2.1.)
See [Groonga's `fuzzy_max_distance_ratio` option][groonga-fuzzy-max-distance-ratio] for details.

All arguments of `pgroonga_condition()` are optional. If you want to specify a particular argument, you can use [Named Notation][sql-syntax-calling-funcs-named] such as `name => value` without relying on its position. For example, if you specify only `index_name` argument, you can write `pgroonga_condition(index_name => 'index1')`.

In general, it is enough to remember the following three cases.

```sql
pgroonga_condition('keyword', index_name => 'pgroonga_index')
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')
```

Please refer to [Calling Functions][sql-syntax-calling-funcs] for information about the difference between when you need to write `name => value` and when you don't.

## Usage

### Specify `index_name`

Introducing how to search with normalizer and tokeniser options specified in the index while sequential search is executed.

Use `pgroonga_condition('keyword', index_name => 'pgroonga_index')`.
Assign the name of index specified tokenizer or normalizer to `index_name`.

Here are sample schema and data:

```sql
CREATE TABLE tags (
  name text PRIMARY KEY
);

CREATE INDEX pgroonga_tag_name_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2)
  WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');

INSERT INTO tags VALUES ('PostgreSQL');
INSERT INTO tags VALUES ('Groonga');
INSERT INTO tags VALUES ('PGroonga');
INSERT INTO tags VALUES ('pglogical');
```

At the time of an index search, you can customize the behavior of the index search by using the options specified to the index.
In the above example, the options are specified in the `normalizers='...'` section.

On the other hand, at the sequential search, the options specified to the index cannot be referenced.
It is because there is no information which index to be referenced at the sequential search.

Because of that, there is a possibility that the search results may differ between a sequential search and an index search.
In order to avoid this issue, explicitly specify which index to be referenced at the sequential search.
The `index_name => '...'` argument in `pgroonga_condition()` is used for that.


The next example executes a prefix search with the keyword "`_p_G`" while `NormalizerNFKC150("remove_symbol", true)` is specified in the index.
Since [`remove_symbol`][remove-symbol] is the option to ignore the symbols, "`_p_G`" is normalized to "`pg`".
(The reason why the capital letter "`G`" becomes a lowercase "`g`" is not due to the `remove_symbol` option, but rather the default behavior of `NormalizerNFKC150`.)
Therefore, both "`PGroonga`" and "`pglogical`" should be hit while this option is active.

You can see that "`PGroonga`" and "`pglogical`" are hit as a result of the sequential search.
This result shows that `NormalizerNFKC150("remove_symbol", true)` specified in the index is referenced even during sequential search execution.

```sql
EXPLAIN ANALYZE
SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G',
                                  index_name => 'pgroonga_tag_name_index');
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Seq Scan on tags  (cost=0.00..1043.60 rows=1 width=32) (actual time=2.267..2.336 rows=2 loops=1)
   Filter: (name &^ '(_p_G,,,,pgroonga_tag_name_index,)'::pgroonga_condition)
   Rows Removed by Filter: 2
 Planning Time: 0.871 ms
 Execution Time: 2.352 ms
(5 rows)

SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G',
                                  index_name => 'pgroonga_tag_name_index');
   name
-----------
 PGroonga
 pglogical
(2 rows)
```

As you can see in next, "`PGroonga`" and "`pglogical`" would not be hit when `index_name` is not specified. (This means that `NormalizerNFKC150("remove_symbol", true)` cannot be referenced.)

```sql
EXPLAIN ANALYZE
SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G');
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Seq Scan on tags  (cost=0.00..1043.60 rows=1 width=32) (actual time=0.032..0.032 rows=0 loops=1)
   Filter: (name &^ '(_p_G,,,,,)'::pgroonga_condition)
   Rows Removed by Filter: 4
 Planning Time: 0.910 ms
 Execution Time: 0.053 ms
(5 rows)

SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G');

 name
------
(0 rows)
```

In this way, by specifying `index_name`, you can ensure that the search result remain the same whether executing a sequential search or an index search.

### Specify `weights`

Introducing how to specify different weights for each column.
This allows the title to be weighted more than the main text.

Use `pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])`.
`weight1`, `weight2`, and so on specify the weights for each column.

Here are sample schema and data:

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]));

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is the fast full text search engine optimized for Japanese.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension for PostgreSQL to use Groonga as the index.');
INSERT INTO memos VALUES ('command line', 'There is a groonga command.');
```

[`pgroonga_score function`][pgroonga-score-function] can be used to search for records that match by the specified query.

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@~
       pgroonga_condition('Groonga OR PostgreSQL', ARRAY[5, 1])
 ORDER BY score DESC;
    title     |                               content                                | score 
--------------+----------------------------------------------------------------------+-------
 Groonga      | Groonga is the fast full text search engine optimized for Japanese.  |     6
 PostgreSQL   | PostgreSQL is a relational database management system.               |     6
 PGroonga     | PGroonga is an extension for PostgreSQL to use Groonga as the index. |     2
 command line | There is a groonga command.                                          |     1
(4 rows)
```

In above example, the title is 5 times weighted that the main text because `ARRAY[title, content] &@~ pgroonga_condition('Groonga OR PostgreSQL', ARRAY[5, 1])` is specified.
You can see the score is higher for the records with `Groonga` or `PostgreSQL` in the `title` column compared to records with `Groonga` or `PostgreSQL` in the `content` column.

### Exclude from search target

Introducing how to search without specific columns as the search target.

Use `pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])`.
You need to specify `0` to `weight` of the column that would be excluded from the search target.

Here are sample schema and data:

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]));

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is the fast full text search engine optimized for Japanese.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension for PostgreSQL to use Groonga as the index.');
INSERT INTO memos VALUES ('command line', 'There is a groonga command.');
```

In the next example, the `content` column is excluded from the search target.
The record, `'PGroonga is an extension for PostgreSQL to use Groonga as the index.'`, should be hit if the `content` column is included in the search target with the search keyword is "`extension`", but the record is not hit.
You can see that the `content` column is excluded from the search target.

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
       pgroonga_condition('extension', ARRAY[1, 0]);
 title | content 
-------+---------
(0 rows)
```

As the `content` column is set as the search target in the next example, the record `'PGroonga is an extension for PostgreSQL to use Groonga as an index.'` is hit.

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
       pgroonga_condition('extension', ARRAY[1, 1]);
  title   |                               content                                
----------+----------------------------------------------------------------------
 PGroonga | PGroonga is an extension for PostgreSQL to use Groonga as the index.
(1 row)
```

### Typo tolerance search

Introducing how to search with typo tolerance.
A user often typo.
typo tolerance search to provide a better search experience.

Use `pgroonga_condition('keyword', fuzzy_max_distance_ratio => ratio)`.
The number of typo characters allowed depends on the value of `ratio`.
Please see [Groonga's documentation][groonga-typo-tolerance] for detailed character count calculations.
We recommend `0.34` for `ratio`.

Here are sample schema and data:

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]));

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is the fast full text search engine optimized for Japanese.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension for PostgreSQL to use Groonga as the index.');
INSERT INTO memos VALUES ('command line', 'There is a groonga command.');
```

Here is an example that shows that we can search `Groonga` with `Moronga` (2 typos):
Of course, if you search as is, you will not get any hits.

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
         pgroonga_condition('Moronga');
 title | content 
-------+---------
(0 rows)
```

Use `fuzzy_max_distance_ratio` option to hit records containing `Groonga`.

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
         pgroonga_condition(
           'Moronga',
           fuzzy_max_distance_ratio => 0.34
         );
    title     |                               content                                
--------------+----------------------------------------------------------------------
 Groonga      | Groonga is the fast full text search engine optimized for Japanese.
 PGroonga     | PGroonga is an extension for PostgreSQL to use Groonga as the index.
 command line | There is a groonga command.
(3 rows)
```

When searching `Groonga`, `0.34` allows 2 typos, resulting in the above results.
For example, if `ratio` is set to `0.2`, only 1 typo is allowed, so it does not hit.

## See also

* [Calling Functions][sql-syntax-calling-funcs]

* [Named Notation][sql-syntax-calling-funcs-named]

* [normalizers_mapping][normalizers-mapping]

* [pgroonga_score function][pgroonga-score-function]

* [postgres_fdw][postgres-fdw]

* [remove_symbol][remove-symbol]

* [score compute procedures][scorer]

* [Groonga's `fuzzy_max_distance_ratio` option][groonga-fuzzy-max-distance-ratio]

  * [Groonga's typo tolerance document][groonga-typo-tolerance]

[sql-syntax-calling-funcs]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html

[sql-syntax-calling-funcs-named]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED

[normalizers-mapping]:../create-index-using-pgroonga.html#custom-normalizer

[pgroonga-score-function]:pgroonga-score.html

[postgres-fdw]:{{ site.postgresql_doc_base_url.en }}/postgres-fdw.html

[remove-symbol]:https://groonga.org/docs/reference/normalizers/normalizer_nfkc150.html#remove-symbol

[scorer]:https://groonga.org/docs/reference/scorer.html

[groonga-fuzzy-max-distance-ratio]:https://groonga.org/docs/reference/commands/select.html#fuzzy-max-distance-ratio

[groonga-typo-tolerance]:https://groonga.org/docs/reference/commands/select.html#typo-tolerance
