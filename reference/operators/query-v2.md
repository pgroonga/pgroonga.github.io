---
title: "&@~ operator for non jsonb types"
upper_level: ../
---

# `&@~` operator for non `jsonb` types

Since 1.2.2.

`&?` operator is deprecated since 1.2.2. Use `&@~` operator instead.

## Summary

`&@~` operator performs full text search with query.

Query's syntax is similar to syntax that is used in Web search engine. For example, you can use OR search by `KEYWORD1 OR KEYWORD2` in query, AND search by `KEYWORD1 KEYWORD2` in query and NOT search by `KEYWORD1 -KEYWORD2` in query.

## Syntax

There are three signatures:

```sql
column &@~ query
column &@~ (query, weights, index_name)::pgroonga_full_text_search_condition
column &@~ (query, weights, scorers, index_name)::pgroonga_full_text_search_condition_with_scorers
column &@~ pgroonga_condition(keyword, weight, index_name => 'index_name')
column &@~ pgroonga_condition(keyword, weight, scorers, index_name => 'index_name')
column &@~ pgroonga_condition(keyword, schema_name => 'schema_name', index_name => 'index_name')
column &@~ pgroonga_condition(keyword, index_name => 'index_name', column_name => 'column_name')
```

The first signature is simpler than others. The first signature is enough for most cases.

The second signature is useful to optimize search score. For example, you can implement "title is more important than content" for blog application.

The second signature is available since 2.0.4. 3.1.7から非推奨になりました。3.1.7以降では、4つ目の使い方を使ってください。

The third signature is useful to optimize more search score. For example, you can take measures against [keyword stuffing][wikipedia-keyword-stuffing].

The third signature is available since 2.0.6. 3.1.7から非推奨になりました。3.1.7以降では、5つ目の使い方を使ってください。

4つ目の使い方は2つ目の使い方と同じです。[`pgroonga_condition()`][pgroonga-condition]を使っている点だけ異なります。
3.1.7以降で検索スコアーを最適化したい場合は、この使い方を使ってください。

4つ目の使い方は3.1.7から使えます。

5つ目の使い方は3つ目の使い方と同じです。`pgroonga_condition()`を使っている点だけが異なります。
3.1.7以降で検索スコア―をより最適化したい場合は、この使い方を使ってください。

5つ目の使い方は3.1.7から使えます。

6つ目の使い方は[postgres_fdw][postgres-fdw]を使って外部のPostgreSQLのデータベースへアクセスする場合に使います。

6つ目の使い方は3.1.7から使えます。

7つ目の使い方は[`normalizers_mapping`][normalizers-mapping]を使って特定の属性に特定のノーマライザーとそのオプションを指定している場合に使います。

7つ目の使い方は3.1.7から使えます。

Here is the description of the first signature.

```sql
column &@~ query
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`query` is a query for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

[Groonga's query syntax][groonga-query-syntax] is used in `query`.

Here is the description of the second signature.

```sql
column &@~ (query, weights, index_name)::pgroonga_full_text_search_condition
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`query` is a query for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

`weights` is importance factors of each value. It's `int[]` type.

If `column` is `text` type or `varchar` type, the first element is used for importance factor of the value. If `column` is `text[]` type, the same position value is used as importance factor.

`weights` can be `NULL`. Elements of `weights` can also be `NULL`. If the corresponding importance factor is `NULL`, the importance factor is `1`.

If importance factor is `0`, the value is ignored. For example, `ARRAY[1, 0, 1]` means the second value isn't search target.

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.

`index_name` can be `NULL`.

It's for using the same search options specified in PGroonga index in sequential search.

It's available since 2.0.6.

Here is the description of the third signature.

```sql
column &@~ (query, weights, scorers, index_name)::pgroonga_full_text_search_condition_with_scorers
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`query` is a query for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

`weights` is importance factors of each value. It's `int[]` type.

If `column` is `text` type or `varchar` type, the first element is used for importance factor of the value. If `column` is `text[]` type, the same position value is used as importance factor.

`weights` can be `NULL`. Elements of `weights` can also be `NULL`. If the corresponding importance factor is `NULL`, the importance factor is `1`.

If importance factor is `0`, the value is ignored. For example, `ARRAY[1, 0, 1]` means the second value isn't search target.

`scorers` is score compute procedures of each value. It's `text[]` type. If `column` is `text` type or `varchar` type, the first element is used to compute score for the value. If `column` is `text[]` type, the same position value is used to compute score for the value.

`scorers` can be `NULL`. Elements of `scorers` can also be `NULL`. If the corresponding scorerer is `NULL`, the scorer is the term count scorer.

See [scorer][groonga-scorer] document in Groonga for scorer details.

Note that you must specify `$index` for the first scorer argument.

Example:

```sql
'scorer_tf_at_most($index, 0.25)'
```

It's replaced with the correct Groonga index name internally.

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.

`index_name` can be `NULL`.

It's for using the same search options specified in PGroonga index in sequential search.

It's available since 2.0.6.

[Groonga's query syntax][groonga-query-syntax] is used in `query`.

以下は4つ目の使い方の説明です。

```sql
column &@~ pgroonga_condition(query, weight, index_name => 'index_name')
```

使い方は、2つ目の使い方と同様です。シーケンシャルサーチのときにもPGroongaのインデックスに指定した検索オプションを使えるようにするために使われます。
`index_name`のみ[「`引数名 => 値`」][sql-syntax-calling-funcs-named]という名前付き表記を使うことに注意してください。

3.1.7から使えます。

以下は5つ目の使い方の説明です。

```sql
column &@~ pgroonga_condition(query, weight, scorers, index_name => 'index_name')
```

使い方は、3つ目の使い方と同様です。スコアラーをカスタマイズし、よりスコアーの最適化できます。
`index_name`のみ[「`引数名 => 値`」][sql-syntax-calling-funcs-named]という名前付き表記を使うことに注意してください。

3.1.7から使えます。

以下は6つ目の使い方の説明です。

```sql
column &@~ pgroonga_condition(query, schema_name => 'schema_name', index_name => 'index_name')
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`query` is a query for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

`schema_name` はシーケンシャルサーチ実行時に参照するインデックスが属するスキーマです。`text`型です。通常のケースでは指定する必要はありません。

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.
「`引数名 => 値`」という名前付き表記を使うことに注意してください。

PostgreSQLは、スキーマ未指定の場合`search_path`に登録されているスキーマから該当するインデックスを検索します。
通常は、`search_path`に存在するスキーマ内に該当するインデックスがあるため`schema_name`を指定しなくても適切なインデックスを参照できます。

しかし、 [postgres_fdw][postgres-fdw]を使って外部のPostgreSQLのデータベースへアクセスする場合、`search_path`は`pg_catalog`のみになります。
このケースでは、`pg_catalog`スキーマ内に参照したいインデックスが存在しない場合、スキーマ未指定では該当のインデックスを発見できません。

このように、`search_path`に登録されているスキーマ以外のスキーマに参照したいインデックスがある場合は、`schema_name`で明示的にスキーマを指定することで
該当のインデックスを発見できます。

これにより、postgres_fdwを使った環境であっても、インデックスサーチ時とシーケンシャルサーチ時で検索結果が異なってしまう状態を避けられます。

3.1.7から使えます。

以下は7つ目の使い方の説明です。

```sql
column &@~ pgroonga_condition(query, index_name => 'index_name', column_name => 'column_name')
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`query` is a query for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

`column_name`はシーケンシャルサーチ実行時に参照するインデックスが紐付けられている属性です。`text`型です。通常のケースでは指定する必要はありません。

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.
「`引数名 => 値`」という名前付き表記を使うことに注意してください。
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

You can perform full text search with multiple keywords by `&@~` operator like `KEYWORD1 KEYWORD2`. You can also do OR search by `KEYWORD1 OR KEYWORD2`:

```sql
SELECT * FROM memos WHERE content &@~ 'PGroonga OR PostgreSQL';
--  id |                            content                             
-- ----+----------------------------------------------------------------
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   1 | PostgreSQL is a relational database management system.
-- (2 rows)
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
 USING pgroonga ((ARRAY[title, content]));
```

```sql
INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES ('CLI', 'There is groonga command.');
```

You can find more suitable records against the given query with [`pgroonga_score` function][score]:

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@~
       ('Groonga OR PostgreSQL',
        ARRAY[5, 1],
        'pgroonga_memos_index')::pgroonga_full_text_search_condition
 ORDER BY score DESC;
--    title    |                                content                                 | score 
-- ------------+------------------------------------------------------------------------+-------
--  Groonga    | Groonga is a fast full text search engine that supports all languages. |     6
--  PostgreSQL | PostgreSQL is a relational database management system.                 |     6
--  PGroonga   | PGroonga is a PostgreSQL extension that uses Groonga as index.         |     2
--  CLI        | There is groonga command.                                              |     1
-- (4 rows)
```

You can confirm that the record which has "`Groonga`" or "`PostgreSQL`" in `title` column has more high score than "`Groonga`" or "`PostgreSQL`" in `content` column.

You can ignore `content` column data by specifying `0` as the second weight value:

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@~
       ('Groonga OR PostgreSQL',
        ARRAY[5, 0],
        'pgroonga_memos_index')::pgroonga_full_text_search_condition
 ORDER BY score DESC;
--    title    |                                content                                 | score 
-- ------------+------------------------------------------------------------------------+-------
--  Groonga    | Groonga is a fast full text search engine that supports all languages. |     5
--  PostgreSQL | PostgreSQL is a relational database management system.                 |     5
-- (2 rows)
```

You can customize how to compute score. For example, you can limit the score of `content` column to `0.5`.

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@~
       ('Groonga OR PostgreSQL',
        ARRAY[5, 1],
        ARRAY[NULL, 'scorer_tf_at_most($index, 0.5)'],
        'pgroonga_memos_index')::pgroonga_full_text_search_condition_with_scorers
 ORDER BY score DESC;
--    title    |                                content                                 | score 
-- ------------+------------------------------------------------------------------------+-------
--  Groonga    | Groonga is a fast full text search engine that supports all languages. |   5.5
--  PostgreSQL | PostgreSQL is a relational database management system.                 |   5.5
--  PGroonga   | PGroonga is a PostgreSQL extension that uses Groonga as index.         |     1
--  CLI        | There is groonga command.                                              |   0.5
-- (4 rows)
```

See [Groonga document][groonga-query-syntax] for query syntax details.

Note that you can't use syntax that starts with `COLUMN_NAME:` like `COLUMN_NAME:@KEYWORD`. It's disabled in PGroonga.

You can't use `COLUMN_NAME:^VALUE` for prefix search. You need to use `VALUE*` for prefix search.

## See also

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [Groonga's query syntax][groonga-query-syntax]

  * [postgres_fdw][postgres-fdw]

  * [normalizers_mapping][normalizers-mapping]

  * [名前付け表記][sql-syntax-calling-funcs-named]

[wikipedia-keyword-stuffing]:https://en.wikipedia.org/wiki/Keyword_stuffing

[groonga-scorer]:http://groonga.org/docs/reference/scorer.html

[score]:../functions/pgroonga-score.html

[match-v2]:match-v2.html

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html

[pgroonga-condition]:../functions/pgroonga-condition.html

[normalizers-mapping]:../create-index-using-pgroonga.html#custom-normalizer

[sql-syntax-calling-funcs-named]:https://www.postgresql.org/docs/current/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED
