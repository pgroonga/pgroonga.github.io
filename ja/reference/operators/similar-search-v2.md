---
title: "&@*演算子"
upper_level: ../
---

# `&@*`演算子

1.2.1で追加。

`&~?`演算子は1.2.2から非推奨です。代わりに`&@*`演算子を使ってください。

## 概要

`&@*`演算子は類似文書検索を実行します。

## 構文

```sql
column &@* document
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`document`は類似文書検索で使う文書です。`column`が`text`型または`text[]`型の場合は型は`text`型です。`column`が`varchar`型の場合は型は`varchar`型です。

類似文書検索は`document`のコンテンツに似たレコードを探します。もし、`document`のコンテンツが短かった場合、類似文書検索はそれほど似ていないレコードも返してしまうかもしれません。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_full_text_search_ops_v2`：`text`型のデフォルト

  * `pgroonga_text_array_full_text_search_ops_v2`：`text[]`型のデフォルト

  * `pgroonga_varchar_full_text_search_ops_v2`：`varchar`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`&@*`演算子を使うと指定した文書と似たレコードを検索できます。

```sql
SELECT * FROM memos WHERE content &@* 'MroongaはGroongaを使うMySQLの拡張機能です。';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
-- (1 row)
```

## シーケンシャルスキャン

シーケンシャルスキャンでは類似文書検索を使うことはできません。シーケンシャルスキャンで類似文書検索を使うと次のエラーが返ります。

```sql
SELECT * FROM memos WHERE content &@* 'MroongaはGroongaを使うMySQLの拡張機能です。';
-- ERROR:  pgroonga: operator &@* is available only in index scan
```

## 日本語向け

日本語の文書を類似文書検索する場合はデフォルトの`TokenBigram`ではなく`TokenMecab`を使う方がよいです。

```sql
CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content)
  WITH (tokenizer='TokenMecab');
```

`TokenMecab`は対象の文書を（ほぼ）単語にトークナイズします。これにより類似文書検索の精度が上がります。

`TokenMecab`トークナイザーの指定方法については[`CREATE INDEX USING pgroonga`][create-index-using-pgroonga]も参照してください。

[create-index-using-pgroonga]:../create-index-using-pgroonga.html
