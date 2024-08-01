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
Thus, it was necessary to add a new type every time when a new attribute value is added, such as `pgroonga_full_text_search_condition_with_XXX` type.
For example, `pgroogna_full_text_search_condition_with_scorers` type was added because of the added new attribute.

The difference between `pgroonga_full_text_search_condition` type and `pgroonga_full_text_search_condition_with_scorers` type is whether `scorers` exist or not. If `scorers` is added to `pgroonga_full_text_search_condition` type, every users are required to insert new `NULL` to make `pgroonga_full_text_search_condition` type regardless of `scorers` usage.

However, installing `pgroonga_condition()` function to make new `pgroonga_condition` type value let a new attribute to be added while keeping backward compatibility.
It is because `pgroonga_condition()` function absorbs incompatibility.

`pgroonga_condition()` function lets current writing style when a new attribute value is added because the function can leave out unnecessary attribute value as following sample.
(In the following sample, `weights`, `scorers`, `schema_name` and `column_name` are left out. The details of attribute values would be noted in next ["Syntax"](#syntax). Here, point is that possibility of leaving out unnecessary attribute values.)

```
title &@~ pgroonga_condition('keyword', index_name => 'index_name')
```

Please note that while using `pgroonga_condition()` function you can leave out attribute values instead you need to describe comment like keyword argument such as `index_name => 'index name'`.

In the above sample, there are mix of attribute values which is like keyword argument or not.
How to separate writing is going to be explained in next ["Syntax"](#syntax).
The point here is there is need of different writing from the current.

## Syntax

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
