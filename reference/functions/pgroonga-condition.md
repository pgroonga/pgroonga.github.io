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

Here is the syntax of this function:

```
pgroonga_condition pgroonga_condition(keyword,
                                      weights,
                                      scorers,
                                      schema_name,
                                      index_name,
                                      column_name)
```

`keyword`は検索したいキーワードです。`text`型です。

`weights`は、検索対象のカラムの重要度です。`int[]`型です。

`scorers`は、検索対象のカラムのスコアーを計算する[スコアラー][scorer]です。`text[]`型です。

`schema_name`は、シーケンシャルサーチ実行時に参照するインデックスが属するスキーマです。`text`型です。

`index_name`は、シーケンシャルサーチ実行時に参照するインデックスです。`text`型です。

`column_name`は、シーケンシャルサーチ実行時に参照するインデックス内のカラムです。`text`型です

`pgroonga_condition()`の引数はすべて省略可能です。引数の位置に依らずに、特定の引数を指定したい場合は[`引数名 => 値`][sql-syntax-calling-funcs-named]という名前付き表記が使えます。たとえば、引数に`index_name`だけ指定する場合は`pgroonga_condition(index_name => 'index1')`となります。

一般的なユースケースでは次の3種類の書き方を覚えておけば十分です。

```
pgroonga_condition('keyword', index_name => 'pgroonga_index')
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')
```

上の例以外の使い方をする場合のために、`引数名 => 値`で記述する必要がある引数とそうでない引数の違いについては、[関数呼び出し][sql-syntax-calling-funcs]を参照してください。

## Usage

## See also

* [postgres_fdw][postgres-fdw]
* [normalizers_mapping][normalizers-mapping]
* [関数呼び出し][sql-syntax-calling-funcs]
* [名前付け表記][sql-syntax-calling-funcs-named]


[postgres-fdw]:{{ site.postgresql_doc_base_url.en }}/postgres-fdw.html
[normalizers-mapping]:../create-index-using-pgroonga.html#custom-normalizer
[scorer]:http://groonga.org/docs//reference/scorer.html
[sql-syntax-calling-funcs]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html
[sql-syntax-calling-funcs-named]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED
