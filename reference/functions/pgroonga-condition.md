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

```
title &@~ ('keyword', NULL, 'index_name')::pgroonga_full_text_search_condition
title &@~ ('keyword', ARRAY[1,1,1,5,0], NULL, 'index_name')::pgroonga_full_text_search_condition_with_scorers
```

It was not possible for existing value creation methods to make new attribute value while keeping backward compatibility.
Thus, it was necessary to add a new type every time a new attribute value is added, such as `pgroonga_full_text_search_condition_with_XXX` type.
For example, `pgroogna_full_text_search_condition_with_scorers` type was added because of the added new attribution.

The difference between `pgroonga_full_text_search_condition` type and `pgroonga_full_text_search_condition_with_scorers` type is whether `scorers` exist or not. If `scorers` is added to `pgroonga_full_text_search_condition` type, every users are required to insert new `NULL` to make `pgroonga_full_text_search_condition` type regardless of `scorers` usage.

However, installing `pgroonga_condition()` function to make new `pgroonga_condition` type value let a new attribution to be added while keeping backward compatibility.
It is because `pgroonga_condition()` function absorbs incompatibility.

`pgroonga_condition()` function let current writing style when a new attribute value is added because the function can leave out unnecessary attribution value as following sample.
(In the following sample, `weights`, `scorers`, `schema_name` and `column_name` are left out. The details of attribute values would be noted in next "Syntax". Here, point is that possibility of leaving out unnecessary attribute values.)

```
title &@~ pgroonga_condition('keyword', index_name => 'index_name')
```

Please note that while using `pgroonga_condition()` functionm you can leaving out attribute values instead you need to describe comment like key word argument such as "index_name => 'index name'".

In the above sample, there are mix of attribute values which is like key word argument or not.
How to separate writing is going to be explained in next ## Syntax.
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

`keyword`は検索キーワードです。`text`型です。

`weights`はそれぞれの値の重要度です。`int[]`型です。

`scorers`はそれぞれの値のスコアーを計算する処理です。`text[]`型です。

`schema_name`はシーケンシャルサーチ実行時に参照するインデックスが属するスキーマです。`text`型です。

`index_name`はシーケンシャルサーチ実行時に参照するインデックスです。`text`型です。

`column_name`はシーケンシャルサーチ実行時に参照するインデックスが紐付けられている属性です。`text`型です。

`pgroonga_condition()`の引数はすべて省略可能です。そのため、[「`引数名 => 値`」][sql-syntax-calling-funcs-named]という名前付き表記を使うことで特定の引数だけ指定することができます。たとえば、`index_name`だけ指定する場合は`pgroonga_condition(index_name => 'index1')`となります。
ただ、一般的なユースケースでは次の3種類の書き方を覚えておけば十分です。

```
title &@~ pgroonga_condition('keyword', index_name => 'pgroonga_index')
title &@~ pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])
title &@~ pgroonga_condition('keyword', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')
```

上の例以外の使い方をする場合のために、「`引数名 => 値`」で記述する必要がある引数とそうでない引数の違いを説明します。
例えば、次は引数`weights`、`scorers`、`schema_name`、`column_name`を省略しています。

```
title &@~ pgroonga_condition('keyword', index_name => 'pgroonga_index')
```

引数`weights`と`scorers`と`schema_name`を省略したことで、引数`index_name`の指定は第2引数の位置にありますが、
関数のシグネチャーでは`index_name`は第5引数なので、このケースでは、`index_name`は関数のシグネチャーと位置が異なる引数となります。
一方、第1引数にある`keyword`は「`引数名 => 値`」という表記ではないので、関数のシグネチャーと位置が同じ引数となります。

つまり、関数のシグネチャーと同じ位置にある、`keyword`は、「`引数名 => 値`」の形で書く必要はなく、値をそのまま記述できますが、
関数のシグネチャーと違う位置にある、`index_name`は、「`引数名 => 値`」の形で書く必要があります。

## Usage

Here are sample schema and data:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (title)
        WITH (normalizers='NormalizerNFKC150("unify_katakana_v_sounds", true)');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');
```

インデックスサーチ時はインデックスに指定したオプションで検索結果をカスタマイズできます。
上のサンプルでは、`normalizers='...'`の部分でオプションを指定しています。
一方、インデックスサーチではなくシーケンシャルサーチが実行されると、PGroongaのインデックスに指定されているオプションを参照できません。
シーケンシャルサーチ時はどのインデックスを参照すればよいかという情報がないからです。

そのため、シーケンシャルサーチ実行時と、インデックスサーチ実行時で検索結果が異なる可能性があります。
この問題を回避するためにシーケンシャルサーチ時に参照するインデックスを明示的に指定できます。`index_name => '...'`がそのための引数です。

次の例は、シーケンシャルサーチが実行されていますが、「バイオリン」で「ヴァイオリン」がヒットしていることが確認できます。
シーケンシャルサーチ実行時でもインデックスに設定されている`NormalizerNFKC150("unify_katakana_v_sounds", true)`が参照できていることがわかります。

```sql
EXPLAIN ANALYZE
SELECT *
  FROM memos
 WHERE title &@~ pgroonga_condition('バイオリン',
                                    index_name => 'pgroonga_memos_index');
                                           QUERY PLAN                                            
-------------------------------------------------------------------------------------------------
 Seq Scan on memos  (cost=0.00..2.52 rows=1 width=100) (actual time=2.230..2.406 rows=2 loops=1)
   Filter: (title &@~ '(バイオリン,,,,pgroonga_memos_index,)'::pgroonga_condition)
   Rows Removed by Filter: 1
 Planning Time: 2.222 ms
 Execution Time: 2.525 ms
(5 rows)

SELECT *
  FROM memos
 WHERE title &@~ pgroonga_condition('バイオリン',
                                    index_name => 'pgroonga_memos_index');
 id |    title     |      content       | tag  
----+--------------+--------------------+------
  2 | ヴァイオリン | content2           | tag2
  1 | ヴァイオリン | Let's play violin! | 
(2 rows)
```

## See also

* [postgres_fdw][postgres-fdw]
* [normalizers_mapping][normalizers-mapping]
* [名前付け表記][sql-syntax-calling-funcs-named]

[postgres-fdw]:{{ site.postgresql_doc_base_url.en }}/postgres-fdw.html
[normalizers-mapping]:../create-index-using-pgroonga.html#custom-normalizer
[sql-syntax-calling-funcs-named]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED
