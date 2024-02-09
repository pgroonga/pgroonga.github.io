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
次のように不要な属性値には`NULL`を指定する必要がありました。

```
title &@~ ('keyword', NULL, 'index_name')::pgroonga_full_text_search_condition
title &@~ ('keyword', ARRAY[1,1,1,5,0], NULL, 'index_name')::pgroonga_full_text_search_condition_with_scorers
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

次のように、`pgroonga_condition()`関数は不要な属性値を省略できるため、新たに属性値が追加されても既存の書き方を維持できます。
(次の例では、`weights`、`scorers`、`schema_name`、`column_name`を省略しています。
属性値の詳細については、後述の「構文」で記載します。ここでは、不要な属性値が省略できることに注目してください。)

```
title &@~ pgroonga_condition('keyword', index_name => 'index_name')
```

`pgroonga_condition()`関数では、上のように属性値を省略できますが、代わりに、「index_name => 'index name'」のように
キーワード引数のような記載が必要になることに注意してください。

上の例では、キーワード引数のような書き方をしている属性値とそうでない属性値があります。
どのように書き分けるかについては、後述の「構文」で記載します。
ここでは、従来とは異なる書き方が必要になることがあるという点に注目してください。

## Syntax

Here is the syntax of this function:

```
pgroonga_condition pgroonga_condition(query,
                                      weights,
                                      scorers,
                                      schema_name,
                                      index_name,
                                      column_name)
```

`query`は検索キーワードです。`text`型です。

`weights`はそれぞれの値の重要度です。`int[]`型です。

`scorers`はそれぞれの値のスコアーを計算する処理です。`text[]`型です。

`schema_name`はシーケンシャルサーチ実行時に参照するインデックスが属するスキーマです。`text`型です。

`index_name`はシーケンシャルサーチ実行時に参照するインデックスです。`text`型です。

`column_name`はシーケンシャルサーチ実行時に参照するインデックスが紐付けられている属性です。`text`型です。

`pgroonga_condition()`の引数はすべて省略可能です。そのため、[「`引数名 => 値`」][sql-syntax-calling-funcs-named]という名前付き表記を使うことで特定の引数だけ指定することができます。たとえば、`index_name`だけ指定する場合は`pgroonga_condition(index_name => 'index1')`となります。
ただ、一般的なユースケースでは次の3種類の書き方を覚えておけば十分です。

```
title &@~ pgroonga_condition('query', index_name => 'pgroonga_index')
title &@~ pgroonga_condition('query', ARRAY[weight1, weight2, ...])
title &@~ pgroonga_condition('query', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')
```

上の例以外の使い方をする場合のために、「`引数名 => 値`」で記述する必要がある引数とそうでない引数の違いを説明します。
例えば、次は引数`weights`、`scorers`、`schema_name`、`column_name`を省略しています。

```
title &@~ pgroonga_condition('query', index_name => 'pgroonga_index')
```

引数`weights`と`scorers`と`schema_name`を省略したことで、引数`index_name`の指定は第2引数の位置にありますが、
関数のシグネチャーでは`index_name`は第5引数なので、このケースでは、`index_name`は関数のシグネチャーと位置が異なる引数となります。
一方、第1引数にある`query`は「`引数名 => 値`」という表記ではないので、関数のシグネチャーと位置が同じ引数となります。

つまり、関数のシグネチャーと同じ位置にある、`query`は、「`引数名 => 値`」の形で書く必要はなく、値をそのまま記述できますが、
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
