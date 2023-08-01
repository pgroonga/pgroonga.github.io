---
title: "jsonb型以外の型用の&@~演算子"
upper_level: ../
---

# `jsonb`型以外の型用の`&@~`演算子

1.2.2で追加。

`&?`演算子は1.2.2から非推奨です。代わりに`&@~`演算子を使ってください。

## 概要

`&@~`演算子はクエリーを使って全文検索を実行します。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。`キーワード1 キーワード2`と書くとAND検索できます。`キーワード1 -キーワード2`と書くとNOT検索できます。

## 構文

使い方は3つあります。

```sql
column &@~ query
column &@~ (query, weights, index_name)::pgroonga_full_text_search_condition
column &@~ (query, weights, scorers, index_name)::pgroonga_full_text_search_condition_with_scorers
```

1つ目の使い方は他の使い方よりもシンプルです。多くの場合は1つ目の使い方で十分です。

2つ目の使い方は検索スコアーを最適化するときに便利です。たとえば、ブログアプリケーションで「タイトルは本文よりも重要」という検索を実現できます。

2つ目の使い方は2.0.4から使えます。

3つ目の使い方は検索スコアーをより最適化するときに便利です。たとえば、[キーワードスタッフィング][wikipedia-keyword-stuffing]対策を実現することができます。

3つ目の使い方は2.0.6から使えます。

以下は1つ目の使い方の説明です。

```sql
column &@~ query
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`query`は全文検索用のクエリーです。`column`が`text`型または`text[]`型なら`query`は`text`型です。`column`が`varchar`型なら`query`は`varchar`型です。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

以下は2つ目の使い方の説明です。

```sql
column &@~ (query, weights, index_name)::pgroonga_full_text_search_condition
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`query`は全文検索用のクエリーです。`column`が`text`型または`text[]`型なら`query`は`text`型です。`column`が`varchar`型なら`query`は`varchar`型です。

`weights`はそれぞれの値の重要度です。`int[]`型です。

もし、`column`が`text`型か`varchar`型なら、最初の要素がカラムの値の重要度になります。`column`が`text[]`型なら、同じ位置の値がその値の重要度になります。

`weights`を`NULL`にできます。`weights`の要素も`NULL`にできます。対応する重要度が`NULL`の場合は重要度は`1`になります。

重要度が`0`の場合は対応する値を無視します。たとえば、`ARRAY[1, 0, 1]`は2番目の値は検索しないという意味になります。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

`index_name`には`NULL`を指定できます。

これはシーケンシャルサーチのときにもPGroongaのインデックスに指定した検索オプションを使えるようにするために使われます。

2.0.6から使えます。

以下は3つ目の使い方の説明です。

```sql
column &@~ (query, weights, scorers, index_name)::pgroonga_full_text_search_condition_with_scorers
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`query`は全文検索用のクエリーです。`column`が`text`型または`text[]`型なら`query`は`text`型です。`column`が`varchar`型なら`query`は`varchar`型です。

`weights`はそれぞれの値の重要度です。`int[]`型です。

もし、`column`が`text`型か`varchar`型なら、最初の要素がカラムの値の重要度になります。`column`が`text[]`型なら、同じ位置の値がその値の重要度になります。

`weights`を`NULL`にできます。`weights`の要素も`NULL`にできます。対応する重要度が`NULL`の場合は重要度は`1`になります。

重要度が`0`の場合は対応する値を無視します。たとえば、`ARRAY[1, 0, 1]`は2番目の値は検索しないという意味になります。

`scorers`はそれぞれの値のスコアーを計算する処理です。`text[]`型です。もし、`column`が`text`型か`varchar`型なら、最初の要素がカラムの値のスコアーを計算します。`column`が`text[]`型なら、同じ位置の値がその値のスコアーを計算します。

`scorers`を`NULL`にできます。`scorers`の要素も`NULL`にできます。対応するスコアラーが`NULL`の場合は単語の出現数をスコアーにするスコアラーを使います。

スコアラーの詳細はGroongaの[スコアラー][groonga-scorer]のドキュメントを参照してください。

スコアラーの最初の引数には`$index`を指定しなければいけないことに注意してください。

例：

```sql
'scorer_tf_at_most($index, 0.25)'
```

`$index`は内部的に適切なGroongaのインデックス名に置き換えられます。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

`index_name`には`NULL`を指定できます。

これはシーケンシャルサーチのときにもPGroongaのインデックスに指定した検索オプションを使えるようにするために使われます。

2.0.6から使えます。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_full_text_search_ops_v2`：`text`型のデフォルト

  * `pgroonga_text_array_full_text_search_ops_v2`：`text[]`型のデフォルト

  * `pgroonga_varchar_full_text_search_ops_v2`：`varchar`用

  * `pgroonga_text_full_text_search_ops`：`text`用

  * `pgroonga_text_array_full_text_search_ops`：`text[]`用

  * `pgroonga_varchar_full_text_search_ops`：`varchar`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`&@~`演算子を使うと`キーワード1 キーワード2`のように複数のキーワードを指定して全文検索できます。`キーワード1 OR キーワード2`のようにOR検索することもできます。

```sql
SELECT * FROM memos WHERE content &@~ 'PGroonga OR PostgreSQL';
--  id |                                  content
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
-- (2 rows)
```

「タイトルは本文よりも重要」も実現できます。

例に使うサンプルスキーマとデータは次の通りです。

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
INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES ('Groonga', 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES ('PGroonga', 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES ('コマンドライン', 'groongaコマンドがあります。');
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
--      title      |                                  content                                  | score 
-- ----------------+---------------------------------------------------------------------------+-------
--  Groonga        | Groongaは日本語対応の高速な全文検索エンジンです。                         |     6
--  PostgreSQL     | PostgreSQLはリレーショナル・データベース管理システムです。                |     6
--  PGroonga       | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。 |     2
--  コマンドライン | groongaコマンドがあります。                                               |     1
-- (4 rows)
```

`title`カラムに「`Groonga`」または「`PostgreSQL`」があるレコードの方が`content`カラムに「`Groonga`」または「`PostgreSQL`」がある方がスコアーが高いことを確認できます。

2番目の重みの値に`0`を指定すると`content`カラムを無視できます。

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@~
       ('Groonga OR PostgreSQL',
        ARRAY[5, 0],
        'pgroonga_memos_index')::pgroonga_full_text_search_condition
 ORDER BY score DESC;
--    title    |                          content                           | score 
-- ------------+------------------------------------------------------------+-------
--  Groonga    | Groongaは日本語対応の高速な全文検索エンジンです。          |     5
--  PostgreSQL | PostgreSQLはリレーショナル・データベース管理システムです。 |     5
-- (2 rows)
```

スコアーの計算方法をカスタマイズできます。たとえば、`content`カラムのスコアーを最大で`0.5`に制限できます。

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@~
       ('Groonga OR PostgreSQL',
        ARRAY[5, 1],
        'pgroonga_memos_index')::pgroonga_full_text_search_condition
 ORDER BY score DESC;
--      title      |                                  content                                  | score 
-- ----------------+---------------------------------------------------------------------------+-------
--  Groonga        | Groongaは日本語対応の高速な全文検索エンジンです。                         |   5.5
--  PostgreSQL     | PostgreSQLはリレーショナル・データベース管理システムです。                |   5.5
--  PGroonga       | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。 |     1
--  コマンドライン | groongaコマンドがあります。                                               |   0.5
-- (4 rows)
```

クエリーの構文の詳細は[Groongaのドキュメント][groonga-query-syntax]を参照してください。

`カラム名:@キーワード`のように`カラム名:`から始まる構文を使うことはできません。これはPGroongaで無効にしています。

前方一致検索のために`カラム名:^値`という構文を使うことができません。前方一致検索には`値*`を使ってください。

## 参考

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [Groongaのクエリーの構文][groonga-query-syntax]

[wikipedia-keyword-stuffing]:https://ja.wikipedia.org/wiki/%E3%82%AD%E3%83%BC%E3%83%AF%E3%83%BC%E3%83%89%E3%82%B9%E3%82%BF%E3%83%83%E3%83%95%E3%82%A3%E3%83%B3%E3%82%B0

[groonga-scorer]:http://groonga.org/ja/docs/reference/scorer.html

[score]:../functions/pgroonga-score.html

[match-v2]:match-v2.html

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html
