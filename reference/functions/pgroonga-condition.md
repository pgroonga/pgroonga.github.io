---
title: pgroonga_condition function
upper_level: ../
---

# `pgroonga_condition()` function

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
                                      column_name)
```

`keyword` is a keyword for full text search. It's `text` type.

`weights` is importance factors of each value. It's `int[]` type.

`scorers` is [score compute procedures][scorer] of each value. It's `text[]` type.

`schema_name` is the schema to which the index that PGroonga refers to when executing a sequential search belongs. It's `text` type.

`index_name` is index which PGroonga refer to when executing sequential search. It's `text` type.

`column_name` is the column within the index which PGroonga refers to when executing a sequential search. It's `text` type.

All arguments of `pgroonga_condition()` are optional. If you want to specify a particular argument, you can use [Named Notation][sql-syntax-calling-funcs-named] such as `name => value` without relying on its position. For example, if you specify only `index_name` argument, you can write `pgroonga_condition(index_name => 'index1')`.

In general, it is enough to remember the following three cases.

```sql
pgroonga_condition('keyword', index_name => 'pgroonga_index')
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')
```

Please refer to [Calling Functions][sql-syntax-calling-funcs] for information about the difference between when you need to write `name => value` and when you don't.

## Usage

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

インデックスサーチ時はインデックスに指定したオプションを使ってインデックスサーチ時の挙動をカスタマイズできます。
上のサンプルでは、`normalizers='...'`の部分でオプションを指定しています。

一方、インデックスサーチではなくシーケンシャルサーチが実行されると、インデックスに指定されているオプションは参照できません。
シーケンシャルサーチ時はどのインデックスを参照すればよいかという情報がないからです。

インデックスを参照できないということは、インデックスに設定されているノーマライザーやトークナイザーの情報を参照できず、適用もできません。
そのためシーケンシャルサーチ実行時は、インデックスサーチ実行時と検索結果が異なる可能性があります。
この問題を回避するためにシーケンシャルサーチ時に参照するインデックスを明示的に指定します。
`pgroonga_condition()`の`index_name => '...'`がそのための引数です。

次の例は、「-p_G」というキーワードで前方一致検索をしていますが、シーケンシャルサーチであっても、「PGroonga」と「pglogical」がヒットしています。
このことから、シーケンシャルサーチ実行時でもインデックスに設定されている`NormalizerNFKC150("remove_symbol", true)`が参照できていることがわかります。

```sql
EXPLAIN ANALYZE
SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('-p_G',
                                  index_name => 'pgroonga_tag_name_index');
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Seq Scan on tags  (cost=0.00..1043.60 rows=1 width=32) (actual time=2.267..2.336 rows=2 loops=1)
   Filter: (name &^ '(-p_G,,,,pgroonga_tag_name_index,)'::pgroonga_condition)
   Rows Removed by Filter: 2
 Planning Time: 0.871 ms
 Execution Time: 2.352 ms
(5 rows)

SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('-p_G',
                                  index_name => 'pgroonga_tag_name_index');
   name
-----------
 PGroonga
 pglogical
(2 rows)
```

`index_name`を指定しない場合（つまり、`NormalizerNFKC150("remove_symbol", true)`が参照できない場合）は、次のように「PGroonga」と「pglogical」はヒットしません。

```sql
EXPLAIN ANALYZE
SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('-p_G');
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Seq Scan on tags  (cost=0.00..1043.60 rows=1 width=32) (actual time=0.032..0.032 rows=0 loops=1)
   Filter: (name &^ '(-p_G,,,,,)'::pgroonga_condition)
   Rows Removed by Filter: 4
 Planning Time: 0.910 ms
 Execution Time: 0.053 ms
(5 rows)

SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('-p_G');

 name
------
(0 rows)
```

このように、`index_name`を指定することで、シーケンシャルサーチ実行時でもインデックスサーチ実行時でも検索結果が変わらないようにできます。

また、カラム毎の`weight`も設定できます。
つまり、「タイトルは本文よりも重要」を実現できます。

カラム毎の`weight`を設定するためには、 `pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])` を使います。
`weight1`、 `weight2`でカラム毎の重要度を指定できます。

例に使うサンプルスキーマとデータは次の通りです。

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
INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES ('Groonga', 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES ('PGroonga', 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES ('コマンドライン', 'groongaコマンドがあります。');
```

より指定したクエリーにマッチしたレコードを探すためには[pgroonga_score function][pgroonga-score-function]を使えます。

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@~
       pgroonga_condition('Groonga OR PostgreSQL', ARRAY[5, 1])
 ORDER BY score DESC;
      title      |                                  content                                  | score 
----------------+---------------------------------------------------------------------------+-------
 Groonga        | Groongaは日本語対応の高速な全文検索エンジンです。                         |     6
 PostgreSQL     | PostgreSQLはリレーショナル・データベース管理システムです。                |     6
 PGroonga       | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。 |     2
 コマンドライン | groongaコマンドがあります。                                               |     1
(4 rows)
```

上の例では、`ARRAY[title, content] &@~ pgroonga_condition('Groonga OR PostgreSQL', ARRAY[5, 1])`と指定しているので、タイトルが本文より5倍重要としています。
titleカラムに「Groonga」または「PostgreSQL」があるレコードの方がcontentカラムに「Groonga」または「PostgreSQL」がある方よりスコアーが高いことを確認できます。

`pgroonga_condition('keyword', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')`は、検索対象のカラムを選択する場合に使います。
`weight`を`0`にすることで、対応するカラムを無視できます。次の例では、`content`カラムを無視して検索します。

`content`カラムも検索対象としている場合は、「-p_G」というキーワードで前方一致検索しているので、`'PGroonga', 'PostgreSQLの拡張機能です。'`がヒットするはずですが、次の例では、`content`カラムを無視して検索しているため、このレコードはヒットしていません。
次の例のように、検索対象のカラムを選択しつつ、インデックスに設定されているノーマライザーやトークナイザーを参照して検索したい場合には、この書き方を使ってください。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]) pgroonga_text_array_term_search_ops_v2)
 WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES ('Groonga', 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES ('PGroonga', 'PostgreSQLの拡張機能です。');
INSERT INTO memos VALUES ('pglogical', 'pglogicalは、論理レプリケーションを実装しています。');

EXPLAIN ANALYZE VERBOSE SELECT *
  FROM memos
 WHERE ARRAY[title, content] &^ pgroonga_condition('-p_O',
                                                   ARRAY[1, 1],
                                                   index_name => 'pgroonga_memos_index');
                                                  QUERY PLAN
---------------------------------------------------------------------------------------------------------------
 Seq Scan on public.memos  (cost=0.00..678.80 rows=1 width=64) (actual time=0.209..0.423 rows=2 loops=1)
   Output: title, content
   Filter: (ARRAY[memos.title, memos.content] &^ '(-p_O,"{1,1}",,,pgroonga_memos_index,)'::pgroonga_condition)
   Rows Removed by Filter: 2
 Planning Time: 0.216 ms
 Execution Time: 0.437 ms
(6 rows)

SELECT *
  FROM memos
 WHERE ARRAY[title, content] &^ pgroonga_condition('-p_O',
                                                   ARRAY[1, 0],
                                                   index_name => 'pgroonga_memos_index');
   title    |                          content
------------+------------------------------------------------------------
 PostgreSQL | PostgreSQLはリレーショナル・データベース管理システムです。
(1 row)
```

## See also

* [Calling Functions][sql-syntax-calling-funcs]

* [Named Notation][sql-syntax-calling-funcs-named]

* [normalizers_mapping][normalizers-mapping]

* [pgroonga_score function][pgroonga-score-function]

* [postgres_fdw][postgres-fdw]

* [score compute procedures][scorer]


[sql-syntax-calling-funcs]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html

[sql-syntax-calling-funcs-named]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED

[normalizers-mapping]:../create-index-using-pgroonga.html#custom-normalizer

[pgroonga-score-function]:pgroonga-score.html

[postgres-fdw]:{{ site.postgresql_doc_base_url.en }}/postgres-fdw.html

[scorer]:https://groonga.org/docs/reference/scorer.html
