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

インデックスサーチ実行時はインデックスに指定したオプションで検索結果をカスタマイズできますが、シーケンシャルサーチ実行時は、PGroongaのインデックスに指定されているオプションを参照できません。
シーケンシャルサーチ実行時はどのインデックスを参照すればよいかという情報がないからです。
シーケンシャルサーチ時に参照するインデックスを`index_name => '...'`で明示的に指定することで、この問題を回避できます。

ただ、[`postgres_fdw`][postgres-fdw]を使って外部のPostgreSQLのデータベースへアクセスする場合は、参照するインデックスを`index_name => '...'`で明示的に指定しても
適切なインデックスを参照してくれません。

PostgreSQLは、スキーマ未指定の場合`search_path`に登録されているスキーマから該当するインデックスを検索します。
通常は、`search_path`に存在するスキーマ内に該当するインデックスがあるため`schema_name`を指定しなくても適切なインデックスを参照できます。

しかし、`postgres_fdw`を使って外部のPostgreSQLのデータベースへアクセスする場合、`search_path`は`pg_catalog`のみになります。
このケースでは、`pg_catalog`スキーマ内に参照したいインデックスが存在しない場合、スキーマ未指定では該当のインデックスを発見できません。

このように、`search_path`に登録されていないスキーマに参照したいインデックスがある場合は、`schema_name`で明示的にスキーマを指定することで
該当のインデックスを発見できます。
これにより、`postgres_fdw`を使った環境であっても、インデックスサーチ時とシーケンシャルサーチ時で検索結果が異なってしまう状態を避けられます。

3.1.7から使えます。

以下は7つ目の使い方の説明です。

```sql
column &@~ pgroonga_condition(query, index_name => 'index_name', column_name => 'column_name')
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`query` is a query for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

`column_name`はシーケンシャルサーチ実行時に参照するインデックスが紐付けられている属性です。`text`型です。通常のケースでは指定する必要はありません。
「`引数名 => 値`」という名前付き表記を使うことに注意してください。

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.
「`引数名 => 値`」という名前付き表記を使うことに注意してください。

インデックスサーチ実行時はインデックスに指定したオプションで検索結果をカスタマイズできますが、シーケンシャルサーチ実行時は、PGroongaのインデックスに指定されているオプションを参照できません。
シーケンシャルサーチ実行時はどのインデックスを参照すればよいかという情報がないからです。
シーケンシャルサーチ時に参照するインデックスを`index_name => '...'`で明示的に指定することで、この問題を回避できます。

ただ、[`normalizers_mapping`][normalizers-mapping]を使って、特定の属性に特定のノーマライザーとそのオプションを指定している場合は、参照するインデックスを`index_name => '...'`で明示的に指定しても適切なインデックスを参照してくれません。

PGroongaには、インデックスのオプションに`normalizers_mapping`があります。
これは特定の属性に対して、特定のノーマライザーとそのオプションを指定できるものですが、`normalizers_mapping`を使っていると、
属性毎にノーマライザーとそのオプションが異なる場合があり、`index_name => '...'`で明示的に指定しただけでは、参照するノーマライザーとそのオプションを
一意に特定できません。

そのため、`column_name => '...'`を使って、シーケンシャルサーチ実行時にどの属性に紐付いたノーマライザーとそのオプションを使うかを指定することで
参照するノーマライザーとそのオプションを発見できます。
これにより、`normalizers_mapping`を使った環境であっても、インデックスサーチ時とシーケンシャルサーチ時で検索結果が異なってしまう状態を避けられます。

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
 USING PGroonga ((ARRAY[title, content]));
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

`pgroonga_condition()`を使って、カラム毎に重要度を変更したい場合は次のようにします。
重要度が`0`の場合は、対応するカラムを検索対象外にします。
次の例では、`content`カラムが検索対象外になります。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga ((ARRAY[title, content]::text[]))
        WITH (normalizers='NormalizerNFKC150("unify_katakana_v_sounds", true)');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');
INSERT INTO memos VALUES (2, 'チェロ', 'ヴァイオリンだけではなく、チェロも始めました！');

SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content]::text[] &@~ pgroonga_condition('バイオリン',
                                                            ARRAY[5,0],
                                                            index_name => 'pgroonga_momos_index');
 id |    title     |      content       | score 
----+--------------+--------------------+-------
  1 | ヴァイオリン | Let's play violin! |     5
(1 row)
```

`pgroonga_condition()`を使ってスコアーの計算方法をカスタマイズするには、次のようにします。
`pgroonga_condition()`の第3引数に`'scorer_tf_at_most($index, 0.5)'`を指定している点に注目してください。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga ((ARRAY[title, content]::text[]))
        WITH (normalizers='NormalizerNFKC150("unify_katakana_v_sounds", true)');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');
INSERT INTO memos VALUES (2, 'チェロ', 'ヴァイオリンだけではなく、チェロも始めました！');

SELECT *, pgroonga_score(tableoid, ctid) AS socre
  FROM memos
 WHERE ARRAY[title, content]::text[] &@~ pgroonga_condition('バイオリン',
                                                            ARRAY[5,1],
                                                            ARRAY[NULL, 'scorer_tf_at_most($index, 0.5)'],
                                                            index_name => 'pgroonga_momos_index');
 id |    title     |                    content                     | socre 
----+--------------+------------------------------------------------+-------
  1 | ヴァイオリン | Let's play violin!                             |     5
  2 | チェロ       | ヴァイオリンだけではなく、チェロも始めました！ |   0.5
(2 rows)
```

`postgres_fdw`を使って外部データベースを検索するケースで、シーケンシャルサーチの検索結果とインデックスサーチの検索結果が変わらないようにするには、
次のようにします。
`pgroonga_condition()`の第2引数で`schema_name => 'public'`を使って`public`スキーマを指定している点に注目してください。

```sql
SELECT *
  FROM memos
 WHERE title &@~ pgroonga_condition('バイオリン',
                                    schema_name => 'public',
                                    index_name => 'pgroonga_memos_index');
 id |    title     |      content       
----+--------------+--------------------
  1 | ヴァイオリン | Let's play violin!
(1 row)
```

`normalizers_mapping`を使った環境で、インデックスサーチ時とシーケンシャルサーチ時で検索結果が変わらないようにするには、
次のようにします。
`pgroonga_condition()`の第3引数で`column_name => 'title'`を使って`title`属性を指定している点に注目してください。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (title, content)
        WITH (normalizers_mapping='{
                "title": "NormalizerNFKC150(\"unify_katakana_v_sounds\", true)",
                "content": "NormalizerNFKC150"
              }',
              normalizers='NormalizerAuto');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');

SELECT *
  FROM memos
 WHERE title &@~ pgroonga_condition('バイオリン',
                                    index_name => 'pgroonga_memos_index',
                                    column_name => 'title');
 id |    title     |      content       
----+--------------+--------------------
  1 | ヴァイオリン | Let's play violin!
(1 row)
```

上の例では、`title`属性に`unify_katakana_v_sounds`が設定されています。
「バイオリン」で「ヴァイオリン」をヒットさせるためには、`unify_katakana_v_sounds`が有効である必要がありますが、
シーケンシャルサーチが実施された場合、PGroongaのインデックスを参照できず`unify_katakana_v_sounds`が効きません。
そこで、以下のように`pgroonga_condition()`の`column_name`で`title`属性を指定することで、`title`属性に
設定されている`unify_katakana_v_sounds`を使えます。

その結果、上の例のようにシーケンシャルサーチでも「バイオリン」で「ヴァイオリン」をヒットさせることができます。


## See also

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [Groonga's query syntax][groonga-query-syntax]

  * [`pgroonga_condition()`][pgroonga-condition]

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

[sql-syntax-calling-funcs-named]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED

[postgres-fdw]:{{ site.postgresql_doc_base_url.en }}/postgres-fdw.html
