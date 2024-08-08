---
title: pgroonga_condition 関数
upper_level: ../
---

# `pgroonga_condition()` 関数

## 概要

`pgroonga_condition()`関数は`pgroonga_condition`型の値を返します。
関数名と型名が同じですが別物です。
`pgroonga_condition`型は`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型のように複雑な条件式を表現します。 

`pgroonga_condition()`関数は`pgroonga_condition`型の値を作るための便利関数です。
特定の属性値のみを指定して`pgroonga_condition`型の値を作れます。

`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、このような便利関数がなかったため必ず全ての属性値を指定して値を作る必要がありました。

したがって、不要な属性値があっても、`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、次のように不要な属性値には`NULL`を指定する必要がありました。

```
title &@~ ('keyword', NULL, 'index_name')::pgroonga_full_text_search_condition
title &@~ ('keyword', ARRAY[1,1,1,5,0], NULL, 'index_name')::pgroonga_full_text_search_condition_with_scorers
```

型を指定して直接値を作る従来の方法では後方互換性を維持したまま新しい属性を作ることができませんでした。
そのため、新しい属性を追加するたびに`pgroonga_full_text_search_condition_with_XXX`というような新しい型を追加する必要がありました。
たとえば、`pgroogna_full_text_search_condition_with_scorers`型はそのために追加された型です。

`pgroonga_full_text_search_condition`型と`pgroonga_full_text_search_condition_with_scorers`型の違いは`scorers`が存在するかどうかですが、`pgroonga_full_text_search_condition`型に`scorers`を追加してしまうと、`scorers`を使わないユーザーも新たに`NULL`を挿入して`pgroonga_full_text_search_condition`型の値を作らなければなりません。

しかし、`pgroonga_condition`型の値を作るための便利関数`pgroonga_condition()`関数を導入することにより後方互換性を維持したまま`pgroonga_condition`型に新しい属性を追加できます。
`pgroonga_condition()`関数が非互換を吸収してくれるからです。

次のように、`pgroonga_condition()`関数は不要な属性値を省略できるため、新たに属性値が追加されても既存の書き方を維持できます。
(次の例では、`weights`、`scorers`、`schema_name`、`column_name`を省略しています。属性値の詳細については、後述の「構文」で記載します。ここでは、不要な属性値が省略できることに注目してください。)

```
title &@~ pgroonga_condition('keyword', index_name => 'index_name')
```

`pgroonga_condition()`関数では、上のように属性値を省略できますが、代わりに、「index_name => 'index name'」のようにキーワード引数のような記載が必要になることに注意してください。

上の例では、キーワード引数のような書き方をしている属性値とそうでない属性値があります。
どのように書き分けるかについては、後述の「構文」で記載します。
ここでは、従来とは異なる書き方が必要になることがあるという点に注目してください。

## 構文

この関数の構文は次の通りです。

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

## 使い方

## 参考

* [postgres_fdw][postgres-fdw]

* [normalizers_mapping][normalizers-mapping]

* [関数呼び出し][sql-syntax-calling-funcs]

* [名前付け表記の使用][sql-syntax-calling-funcs-named]


[postgres-fdw]:{{ site.postgresql_doc_base_url.en }}/postgres-fdw.html

[normalizers-mapping]:../create-index-using-pgroonga.html#custom-normalizer

[scorer]:https://groonga.org/docs/reference/scorer.html

[sql-syntax-calling-funcs]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html

[sql-syntax-calling-funcs-named]:{{ site.postgresql_doc_base_url.en }}/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED
