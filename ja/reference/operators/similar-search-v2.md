---
title: "&~?演算子"
upper_level: ../
---

# `&~?`演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`&~?`演算子は類似文書検索を実行します。

## 構文

```sql
column &~? document
```

`column`は検索対象のカラムです。

`document`は類似文書検索に利用する文書です。`text`型です。

類似文書検索は`document`のコンテンツに似たレコードを探します。もし、`document`のコンテンツが短かった場合、類似文書検索はそれほど似ていないレコードも返してしまうかもしれません。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga.text_full_text_search_ops_v2);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`&~?`演算子を使うと指定した文書と似たレコードを検索できます。

```sql
SELECT * FROM memos WHERE content &~? 'MroongaはGroongaを使うMySQLの拡張機能です。';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
-- (1 row)
```

## シーケンシャルスキャン

シーケンシャルスキャンでは類似文書検索を使うことはできません。シーケンシャルスキャンで類似文書検索を使うと次のエラーが返ります。

```sql
SELECT * FROM memos WHERE content &~? 'MroongaはGroongaを使うMySQLの拡張機能です。';
-- ERROR:  pgroonga: operator &~? is available only in index scan
```
