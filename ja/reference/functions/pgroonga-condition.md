---
title: pgroonga_condition 関数
upper_level: ../
---

# `pgroonga_condition()` 関数

3.1.6で追加。

## 概要

`pgroonga_condition()`関数は`pgroonga_condition`型の値を返します。
関数名と型名が同じですが別物です。
`pgroonga_condition`型は`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型のように複雑な条件式を表現します。

`pgroonga_condition()`関数は`pgroonga_condition`型の値を作るための便利関数です。
特定の属性値のみを指定して`pgroonga_condition`型の値を作れます。

`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、このような便利関数がなかったため必ず全ての属性値を指定して値を作る必要がありました。

したがって、不要な属性値があっても、`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、次のように不要な属性値には`NULL`を指定する必要がありました。

```sql
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

```sql
title &@~ pgroonga_condition('keyword', index_name => 'index_name')
```

`pgroonga_condition()`関数では、上のように属性値を省略できますが、代わりに、「`index_name => 'index name'`」のようにキーワード引数のような記載が必要になることに注意してください。

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
                                      column_name,
                                      fuzzy_max_distance_ratio)
```

`keyword`は全文検索で使うキーワードです。`text`型です。

`weights`は、検索対象のカラムの重要度です。`int[]`型です。

`scorers`は、検索対象のカラムのスコアーを計算する[スコアラー][scorer]です。`text[]`型です。

`schema_name`は、シーケンシャルサーチ実行時に参照するインデックスが属するスキーマの名前です。`text`型です。

`index_name`は、シーケンシャルサーチ実行時に参照するインデックスの名前です。`text`型です。

`column_name`は、シーケンシャルサーチ実行時に参照するインデックス内のカラムの名前です。`text`型です

`fuzzy_max_distance_ratio`は編集距離の割合です。`float4`型です。（3.2.1で追加。)
詳しくは[Groongaの`fuzzy_max_distance_ratio`オプション][groonga-fuzzy-max-distance-ratio]をご覧ください。

`pgroonga_condition()`の引数はすべて省略可能です。引数の位置に依らずに、特定の引数を指定したい場合は[`引数名 => 値`][sql-syntax-calling-funcs-named]という名前付き表記が使えます。たとえば、引数に`index_name`だけ指定する場合は`pgroonga_condition(index_name => 'index1')`となります。

一般的なユースケースでは次の3種類の書き方を覚えておけば十分です。

```sql
pgroonga_condition('keyword', index_name => 'pgroonga_index')
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])
pgroonga_condition('keyword', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')
```

上の例以外の使い方をする場合のために、`引数名 => 値`で記述する必要がある引数とそうでない引数の違いについては、[関数呼び出し][sql-syntax-calling-funcs]を参照してください。

## 使い方

### `index_name`を指定する

シーケンシャルサーチ実行時でも、インデックスに指定したノーマライザーやトークナイザーのオプションを使って検索する方法を紹介します。

`pgroonga_condition('keyword', index_name => 'pgroonga_index')`を使います。
`index_name`にノーマライザーやトークナイザーを指定したインデックスの名前を指定します。

サンプルスキーマとデータは次の通りです。

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

そのためシーケンシャルサーチ実行時は、インデックスサーチ実行時と検索結果が異なる可能性があります。
この問題を回避するためにシーケンシャルサーチ時に参照するインデックスを明示的に指定します。
`pgroonga_condition()`の`index_name => '...'`がそのための引数です。


次の例は、「`_p_G`」というキーワードで前方一致検索をしており、インデックスには`NormalizerNFKC150("remove_symbol", true)`が設定されています。
[`remove_symbol`][remove-symbol]は記号を無視するオプションなので、「`_p_G`」は「`pg`」にノーマライズされます。
（大文字が小文字になっているのは、`remove_symbol`オプションの挙動ではなく、`NormalizerNFKC150`のデフォルトの挙動によるものです。）
そのため、このオプションが有効であれば、「`PGroonga`」と「`pglogical`」がヒットします。

次の例は、シーケンシャルサーチですが、「`PGroonga`」と「`pglogical`」がヒットしていることが確認できます。
このことから、シーケンシャルサーチ実行時でもインデックスに設定されている`NormalizerNFKC150("remove_symbol", true)`が参照できていることが確認できます。

```sql
EXPLAIN ANALYZE
SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G',
                                  index_name => 'pgroonga_tag_name_index');
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Seq Scan on tags  (cost=0.00..1043.60 rows=1 width=32) (actual time=2.267..2.336 rows=2 loops=1)
   Filter: (name &^ '(_p_G,,,,pgroonga_tag_name_index,)'::pgroonga_condition)
   Rows Removed by Filter: 2
 Planning Time: 0.871 ms
 Execution Time: 2.352 ms
(5 rows)

SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G',
                                  index_name => 'pgroonga_tag_name_index');
   name
-----------
 PGroonga
 pglogical
(2 rows)
```

`index_name`を指定しない場合（つまり、`NormalizerNFKC150("remove_symbol", true)`が参照できない場合）は、次のように「`PGroonga`」と「`pglogical`」はヒットしません。

```sql
EXPLAIN ANALYZE
SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G');
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Seq Scan on tags  (cost=0.00..1043.60 rows=1 width=32) (actual time=0.032..0.032 rows=0 loops=1)
   Filter: (name &^ '(_p_G,,,,,)'::pgroonga_condition)
   Rows Removed by Filter: 4
 Planning Time: 0.910 ms
 Execution Time: 0.053 ms
(5 rows)

SELECT *
  FROM tags
 WHERE name &^ pgroonga_condition('_p_G');

 name
------
(0 rows)
```

このように、`index_name`を指定することで、シーケンシャルサーチ実行時でもインデックスサーチ実行時でも検索結果が変わらないようにできます。

### `weights`を指定する

カラム毎に異なるweight（重要度）を設定する方法を紹介します。
これにより、「タイトルを本文よりも重要視する」を実現できます。

`pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])` を使います。
`weight1`、 `weight2`でカラム毎の重要度を指定します。

サンプルスキーマとデータは次の通りです。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]));

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES ('Groonga', 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES ('PGroonga', 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES ('コマンドライン', 'groongaコマンドがあります。');
```

指定したクエリーによりマッチしたレコードを探すためには[`pgroonga_score function`][pgroonga-score-function]を使えます。

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
`title`カラムに「`Groonga`」または「`PostgreSQL`」があるレコードの方が`content`カラムに「`Groonga`」または「`PostgreSQL`」がある方よりスコアーが高いことを確認できます。

### 特定のカラムを検索対象から除外する

特定のカラムを検索対象から除外して検索する方法を紹介します。

`pgroonga_condition('keyword', ARRAY[weight1, weight2, ...])`を使います。
検索対象から除外したいカラムに対応する`weight`に`0`を指定します。

サンプルスキーマとデータは次の通りです。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]));

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES ('Groonga', 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES ('PGroonga', 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES ('コマンドライン', 'groongaコマンドがあります。');
```

次の例では、`content`カラムを検索対象から除外しています。
「`拡張`」というキーワードで全文検索しているので、`content`カラムを検索対象としていれば、`'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。'`がヒットするはずですが、このレコードはヒットしていません。
このことから、`content`カラムが検索対象から除外されていることを確認できます。

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
       pgroonga_condition('拡張', ARRAY[1, 0]);
 title | content
-------+---------
(0 rows)
```

次のように、`content`カラムを検索対象にすると`'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。'`がヒットします。

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
       pgroonga_condition('拡張', ARRAY[1, 1]);
  title   |                                  content
----------+---------------------------------------------------------------------------
 PGroonga | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
(1 row)
```

### タイプミスの許容

タイプミスを許容した検索方法を紹介します。
ユーザはしばしばタイプミスをします。タイプミスを許容した検索を行うことで、よりよい検索体験を提供することができます。

`pgroonga_condition('keyword', fuzzy_max_distance_ratio => ratio)`を使います。
許容するタイプミスの文字数は`ratio`によって変わります。許容するタイプミスの文字数の計算については[Groongaのドキュメント][groonga-typo-tolerance]に解説があるのでそちらをご覧ください。通常は`ratio`に`0.34`を設定しておけば良いです。

サンプルスキーマとデータは次の通りです。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]));

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES ('Groonga', 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES ('PGroonga', 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES ('コマンドライン', 'groongaコマンドがあります。');
```

以下は`Moronga`（2文字のタイプミス）で`Groonga`を検索する例です。もちろん、そのまま検索してもヒットしません。

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
         pgroonga_condition('Moronga');
 title | content 
-------+---------
(0 rows)
```

`fuzzy_max_distance_ratio`オプションを使うことで`Groonga`を含むレコードがヒットします。

```sql
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~
         pgroonga_condition(
           'Moronga',
           fuzzy_max_distance_ratio => 0.34
         );
     title      |                                  content                                  
----------------+---------------------------------------------------------------------------
 Groonga        | Groongaは日本語対応の高速な全文検索エンジンです。
 PGroonga       | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
 コマンドライン | groongaコマンドがあります。
(3 rows)
```

`Groonga`を検索するときに`0.34`が設定されているとタイプミスは2文字まで許容されるため、このような結果になります。`0.2`を設定するとタイプミスは1文字までになるためヒットしなくなります。

## 参考

* [関数呼び出し][sql-syntax-calling-funcs]

* [名前付け表記の使用][sql-syntax-calling-funcs-named]

* [normalizers_mapping][normalizers-mapping]

* [pgroonga_score関数][pgroonga-score-function]

* [postgres_fdw][postgres-fdw]

* [remove_symbol][remove-symbol]

* [スコア計算について][scorer]

* [Groongaの`fuzzy_max_distance_ratio`オプション][groonga-fuzzy-max-distance-ratio]

* [Groongaのタイプミスの許容についてのドキュメント][groonga-typo-tolerance]

[sql-syntax-calling-funcs]:{{ site.postgresql_doc_base_url.ja }}/sql-syntax-calling-funcs.html

[sql-syntax-calling-funcs-named]:{{ site.postgresql_doc_base_url.ja }}/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED

[normalizers-mapping]:../create-index-using-pgroonga.html#custom-normalizer

[pgroonga-score-function]:pgroonga-score.html

[postgres-fdw]:{{ site.postgresql_doc_base_url.ja }}/postgres-fdw.html

[remove-symbol]:https://groonga.org/ja/docs/reference/normalizers/normalizer_nfkc150.html#normalizer-nfkc150-remove-symbol

[scorer]:https://groonga.org/ja/docs/reference/scorer.html

[groonga-fuzzy-max-distance-ratio]:https://groonga.org/ja/docs/reference/commands/select.html#fuzzy-max-distance-ratio

[groonga-typo-tolerance]:https://groonga.org/ja/docs/reference/commands/select.html#typo-tolerance
