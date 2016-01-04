---
title: "@~演算子"
layout: ja
---

# `@~`演算子

## 概要

`@~`演算子は正規表現検索をします。

PostgreSQLは次のような組み込みの正規表現演算子を提供しています。

  * [`SIMILAR TO`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/functions-matching.html#FUNCTIONS-SIMILARTO-REGEXP)

  * [POSIX正規表現](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/functions-matching.html#FUNCTIONS-POSIX-REGEXP)

`SIMILAR TO`はSQL標準をベースにしています。「POSIX正規表現」はPOSIXをベースにしています。これらはそれぞれ違う正規表現の構文を使います。

PGroongaの`@~`演算子はさらに別の正規表現の構文を使います。`@~`は[Ruby](https://www.ruby-lang.org/ja/)で使われている構文を使います。なぜなら、PGroongaはRubyが使っている正規表現エンジンと同じエンジンを使っているからです。そのエンジンは[Onigmo](https://github.com/k-takata/Onigmo)です。完全な構文定義は[Onigmoのドキュメント](https://github.com/k-takata/Onigmo/blob/master/doc/RE.ja)を参照してください。

PGroongaの`@~`演算子はマッチ前に対象文字列を正規化します。これは「POSIX正規表現」の`~*`演算子と似ています。`~*`演算子は大文字小文字の違いを無視してマッチしているかを判断します。

正規化と大文字小文字の違いを無視することは違います。通常、正規化のほうがよりパワフルです。

例1：「`A`」も「`a`」も「`Ａ`」（U+FF21 FULLWIDTH LATIN CAPITAL LETTER A）も「`ａ`」（U+FF41 FULLWIDTH LATIN SMALL LETTER A）もすべて「`a`」に正規化されます。

例2：いわゆる全角カタカナも半角カタカナもどちらも全角カタカナに正規化されます。たとえば、「`ア`」（U+30A2 KATAKANA LETTER A）も「`ｱ`」（U+FF71 HALFWIDTH KATAKANA LETTER A）もどちらも「`ア`」（U+30A2 KATAKANA LETTER A）に正規化されます。

`@~`演算子は正規表現パターンは正規化しないことに注意してください。マッチ対象のテキストだけを正規化します。これは正規表現パターンのなかでは正規化された文字だけを使うべきだということです。

たとえば、パターンに「`Groonga`」を使ってはいけません。そうではなく、「`groonga`」を使うべきです。なぜなら、対象テキスト中の「`G`」は「`g`」に正規化されるからです。対象テキスト中に「`Groonga`」という文字列は決して現れません。

## 構文

```sql
column @~ regular_expression
```

`column`は検索対象のカラムです。

`regular_expression`はパターンとして使う正規表現です。

`column`と`regular_expression`の型は同じでなければいけません。利用可能な型は次の通りです。

  * `text`

  * `varchar`

`column`の値が`regular_expression`パターンにマッチしたら、その式は`true`を返します。

## 使い方

以下は例で使うサンプルスキーマです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga.text_regexp_ops);
```

インデックスを用いて正規表現検索を実行するにはオペレータークラスを指定しなければいけません。利用可能なオペレータークラスは次の通りです。

  * `pgroonga.text_regexp_ops`：`text`型のカラム用のオペレータークラス。

  * `pgroonga.varchar_regexp_ops`：`varchar`型のカラム用のオペレータークラス。

この例では`pgroonga.text_regexp_ops`を使っています。なぜなら`content`カラムは`text`型のカラムだからです。

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

どうして「`PostgreSQLは..`」レコードがマッチしているのでしょうか？`@~`演算しはマッチ前にマッチ対象のテキストを正規化することを思い出してください。つまり、「`PostgreSQLは...`」テキストはマッチ前に「`postgresqlは...`」と正規化されるということです。正規化されたテキストは「`postgresql`」で始まっています。そのため、「`\Apostgresql`」正規表現はこのレコードにマッチします。

"`PGroongaはPostgreSQLの ...`"レコードはマッチしません。このレコードは正規化後のテキストに「`postgresql`」を含んでいますが、「`postgresql`」はテキストの先頭には現れていません。そのためマッチしません。

## 参考

  * [Onigmoの正規表現構文のドキュメント](https://github.com/k-takata/Onigmo/blob/master/doc/RE.ja)

  * [Groongaの正規表現サポートに関するドキュメント](http://groonga.org/ja/docs/reference/regular_expression.html)
