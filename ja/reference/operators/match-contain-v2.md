---
title: "&@>演算子"
---

# `&@>`演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`&@>`演算子はキーワードの配列で全文検索を実行します。1つ以上のキーワードが見つかった場合、そのレコードはマッチしたことになります。

## 構文

```sql
column &@> keywords
```

`column`は検索対象のカラムです。

`keywords`は全文検索するキーワードの配列です。`text[]`型です。

この演算子は`keywords`中の1つ以上のキーワードが`column`の中に含まれていると`true`を返します。

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

`&@>`演算子を使うと複数のキーワードで全文検索を実行できます。

```sql
SELECT * FROM memos WHERE content &@> ARRAY['全文検索', 'データベース'];
--  id |                          content                           
-- ----+------------------------------------------------------------
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (2 rows)
```

`column &@> ARRAY['キーワード1', 'キーワード2']`は`column &? 'キーワード1 OR キーワード2'`と同じです。

## 参考

  * [`&@`演算子](match-v2.html)

  * [`&?`演算子](query-v2.html)
