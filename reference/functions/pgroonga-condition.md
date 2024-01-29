---
title: pgroonga_condition function
upper_level: ../
---

# `pgroonga_condition()` function

## Summary

`pgroonga_condition()`関数は`pgroonga_condition`型の値を返します。
関数名と型名が同じですが別物です。
`pgroonga_condition`型は`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型のように複雑な条件式を表現します。

`pgroonga_condition()`関数は`pgroonga_condition`型の値を作るための便利関数です。
特定の属性値のみを指定して`pgroonga_condition`型の値を作れます。

`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、このような便利関数がなかったため
必ず全ての属性値を指定して値を作る必要がありました。

したがって、不要な属性値があっても、`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、
以下のように不要な属性値には`NULL`を指定する必要がありました。

```
column operator ('keyword', NULL, 'index_name')::pgroonga_full_text_search_condition
column operator ('keyword', ARRAY[1,1,1,5,0], NULL, 'index_name')::pgroonga_full_text_search_condition_with_scorers
```

型を指定して直接値を作る従来の方法では後方互換性を維持したまま新しい属性を作ることができませんでした。
そのため、新しい属性を追加するたびに`pgroonga_full_text_search_condition_with_XXX`というような新しい型を追加する必要がありました。
たとえば、`pgroogna_full_text_search_condition_with_scorers`型はそのために追加された型です。

`pgroonga_full_text_search_condition`型と`pgroonga_full_text_search_condition_with_scorers`型
の違いは`scorers`が存在するかどうかですが、`pgroonga_full_text_search_condition`型に`scorers`を追加してしまうと、
`scorers`を使わないユーザーも新たに`NULL`を挿入して`pgroonga_full_text_search_condition`型の値を作らなければなりません。

しかし、`pgroonga_condition`型の値を作るための便利関数`pgroonga_condition()`関数を導入することにより後方互換性を維持したまま
`pgroonga_condition`型に新しい属性を追加できます。
`pgroonga_condition()`関数が非互換を吸収してくれるからです。

以下のように、`pgroonga_condition()`関数は不要な属性値を省略できるため、新たに属性値が追加されても既存の書き方を維持できます。
(下記の例では、`weights`、`scorers`、`schema_name`、`column_name`を省略しています。
属性値の詳細については、後述の「構文」で記載します。ここでは、不要な属性値が省略できることに注目してください。)

```
column operator pgroonga_condition('keyword', index_name => 'index_name')
```

`pgroonga_condition()`関数では、上記のように属性値を省略できますが代わりに、「index_name => 'index name'」のように
キーワード引数のような記載が必要になることに注意してください。

上記の例では、キーワード引数のような書き方をしている属性値とそうでない属性値があります。
どのように書き分けるかについては、後述の「構文」で記載します。
ここでは、従来とは異なる書き方が必要になることがあるという点に注目してください。

## Syntax

Here is the syntax of this function:

## Usage

Here are sample schema and data:

```sql
...

## See also

