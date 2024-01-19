---
title: pgroonga_condition function
upper_level: ../
---

# `pgroonga_condition` function

## Summary

この関数は、`pgroonga_full_text_search_condition`や`pgroonga_full_text_search_condition_with_scorers`と
同等の機能を持ちます。

`pgroonga_condition()`では、`pgroonga_full_text_search_condition`や`pgroonga_full_text_search_condition_with_scorers`と異なり、
不要な引数を省略できます。
不要な引数を省略できることで、後方互換性を壊すことや新しいユーザー定義の型を作ること無く新しいオプションを追加可能になりました。

`pgroonga_full_text_search_condition`や`pgroonga_full_text_search_condition_with_scorers`では、不要な引数は省略できず
以下のように`NULL`を入れる必要がありました。

```
column operator ('keyword', NULL, 'index_name')::pgroonga_full_text_search_condition
column operator ('keyword', ARRAY[1,1,1,5,0], NULL, 'index_name')::pgroonga_full_text_search_condition_with_scorers
```

いままでは、新しいオプションを追加する際に後方互換性を壊さないように新しい型を追加していました。
例えば、`pgroonga_full_text_search_condition`と`pgroonga_full_text_search_condition_with_scorers`
の違いは、`scorers`を指定できるかどうかですが、もし、`pgroonga_full_text_search_condition`に`scorers`を追加してしまうと、
`scorers`を使わないユーザーも新たに`NULL`を挿入しなければなりません。そうしないとシンタックスエラーになってしまいます。

このように、後方互換性を壊すのを避けるため、新しいオプションを追加する際は合わせて新しいユーザー定義の型を追加していましたが
オプションが増えるごとに型を追加するのは煩雑です。

`pgroonga_condition()`を使えば、以下のように不要なオプションを省略できるので、新しいオプションが追加されてもそれが不要であれば省略できるため
既存の書き方をそのまま継続して使えるようになります。
下記の例では、`weights`、`scorers`、`schema_name`、`column_name`を省略しています。
引数の詳細については、後述の「構文」で記載します。ここでは、不要な引数が省略できることに注目してください。

```
column operator pgroonga_condition('keyword', index_name => 'index_name')
```

`pgroonga_condition()`では、上記のように引数そのものを省略できますが代わりに、「index_name => 'index name'」のように
キーワード引数のような記載が必要になることに注意してください。

上記の例では、キーワード引数のような書き方をしている引数とそうでない引数があります。
どのように書き分けるかについては、後述の「構文」で記載します。
ここでは、`pgroonga_full_text_search_condition`や`pgroonga_full_text_search_condition_with_scorers`とは
異なる引数の書き方が必要になることがあるという点に注目してください。

## Syntax

Here is the syntax of this function:

## Usage

Here are sample schema and data:

```sql
...

## See also

