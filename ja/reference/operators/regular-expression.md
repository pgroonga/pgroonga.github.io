---
title: "@~演算子"
upper_level: ../
---

# `@~`演算子

## 概要

この演算子は1.2.1から非推奨になりました。代わりに[`&~`演算子][regular-expression-v2]を使ってください。

`@~`演算子は正規表現検索をします。

PostgreSQLは次のような組み込みの正規表現演算子を提供しています。

  * [`SIMILAR TO`][postgresql-similar-to]

  * [POSIX正規表現][postgresql-regexp]

`SIMILAR TO`はSQL標準をベースにしています。「POSIX正規表現」はPOSIXをベースにしています。これらはそれぞれ違う正規表現の構文を使います。

PGroongaの`@~`演算子はさらに別の正規表現の構文を使います。`@~`は[Ruby][ruby]で使われている構文を使います。なぜなら、PGroongaはRubyが使っている正規表現エンジンと同じエンジンを使っているからです。そのエンジンは[Onigmo][onigmo]です。完全な構文定義は[Onigmoのドキュメント][onigmo-document]を参照してください。

PGroongaの`@~`演算子はマッチ前に対象文字列を正規化します。これは「POSIX正規表現」の`~*`演算子と似ています。`~*`演算子は大文字小文字の違いを無視してマッチしているかを判断します。

正規化と大文字小文字の違いを無視することは違います。通常、正規化のほうがよりパワフルです。

例1：「`A`」も「`a`」も「`Ａ`」（U+FF21 FULLWIDTH LATIN CAPITAL LETTER A）も「`ａ`」（U+FF41 FULLWIDTH LATIN SMALL LETTER A）もすべて「`a`」に正規化されます。

例2：いわゆる全角カタカナも半角カタカナもどちらも全角カタカナに正規化されます。たとえば、「`ア`」（U+30A2 KATAKANA LETTER A）も「`ｱ`」（U+FF71 HALFWIDTH KATAKANA LETTER A）もどちらも「`ア`」（U+30A2 KATAKANA LETTER A）に正規化されます。

`@~`演算子は正規表現パターンは正規化しないことに注意してください。マッチ対象のテキストだけを正規化します。これは正規表現パターンのなかでは正規化された文字だけを使うべきだということです。

たとえば、パターンに「`Groonga`」を使ってはいけません。そうではなく、「`groonga`」を使うべきです。なぜなら、対象テキスト中の「`G`」は「`g`」に正規化されるからです。対象テキスト中に「`Groonga`」という文字列は決して現れません。

いくつかのシンプルな正規表現のパターンはGroonga内でインデックスを使って検索します。インデックスを使った場合は非常に高速です。インデックスを使って検索可能なパターンの詳細は[Groongaの正規表現のドキュメント](http://groonga.org/ja/docs/reference/regular_expression.html#regular-expression-index)を参照してください。

もし、正規表現のパターンをインデックスを使って検索できない場合、Groonga内でシーケンシャルスキャンで検索します。

`EXPLAIN`でPostgreSQLがPGroongaのインデックスを使っているとレポートするときでも、Groongaは正規表現のパターンを使った検索をシーケンシャルスキャンで実現するかもしれないことに注意してください。

## 構文

```sql
column @~ regular_expression
```

`column`は検索対象のカラムです。型は`text`型か`varchar`型です。

`regular_expression`はパターンとして使う正規表現です。`column`の型が`text`型のときは`text`型です。`column`の型が`varchar`型のときは`varchar`型です。

`column`の値が`regular_expression`パターンにマッチしたら、その式は`true`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_regexp_ops_v2`：`text`用

  * `pgroonga_varchar_regexp_ops_v2`：`varchar`用

  * `pgroonga_text_regexp_ops`：`text`用

  * `pgroonga_varchar_regexp_ops`：`varchar`用

## 使い方

以下は例で使うサンプルスキーマです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga_text_regexp_ops_v2);
```

以下は例で使うデータです。

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`@~`演算子を使うと正規表現検索を実行できます。

```sql
SELECT * FROM memos WHERE content @~ '\Apostgresql';
--  id |                          content                           
-- ----+------------------------------------------------------------
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
-- (1 row)
```

「`\Apostgresql`」の中の「`\A`」はRubyの正規表現構文では特別な記法です。これはテキストの最初という意味です。つまり、このパターンは「`postgresql`」がテキストの最初に現れること、という意味です。

どうして「`PostgreSQLは..`」レコードがマッチしているのでしょうか？`@~`演算子はマッチ前にマッチ対象のテキストを正規化することを思い出してください。つまり、「`PostgreSQLは...`」テキストはマッチ前に「`postgresqlは...`」と正規化されるということです。正規化されたテキストは「`postgresql`」で始まっています。そのため、「`\Apostgresql`」正規表現はこのレコードにマッチします。

"`PGroongaはPostgreSQLの ...`"レコードはマッチしません。このレコードは正規化後のテキストに「`postgresql`」を含んでいますが、「`postgresql`」はテキストの先頭には現れていません。そのためマッチしません。

## 参考

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [Onigmoの正規表現構文のドキュメント][onigmo-document]

  * [Groongaの正規表現サポートに関するドキュメント][groonga-regular-expression]

[regular-expression-v2]:regular-expression-v2.html

[postgresql-similar-to]:{{ site.postgresql_doc_base_url.ja }}/functions-matching.html#FUNCTIONS-SIMILARTO-REGEXP

[postgresql-regexp]:{{ site.postgresql_doc_base_url.ja }}/functions-matching.html#FUNCTIONS-POSIX-REGEXP

[ruby]:https://www.ruby-lang.org/ja/

[onigmo]:https://github.com/k-takata/Onigmo

[onigmo-document]:https://github.com/k-takata/Onigmo/blob/master/doc/RE.ja

[groonga-regular-expression]:http://groonga.org/ja/docs/reference/regular_expression.html#regular-expression-index

