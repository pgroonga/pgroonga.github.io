---
title: "&`演算子"
layout: ja
---

# `` &` ``演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`` &` ``演算子は[スクリプト構文](http://groonga.org/ja/docs/reference/grn_expr/script_syntax.html)で書かれた検索条件で検索します。スクリプト構文は強力な構文です。全文検索、前方一致検索、範囲検索といった多くの演算を使えます。

## 構文

```sql
column &` script
```

`column`は検索対象のカラムです。

`script`は検索条件を指定したスクリプトです。`text`型です。

`script`の構文は[スクリプト構文](http://groonga.org/ja/docs/reference/grn_expr/script_syntax.html)です。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (id, content pgroonga.text_full_text_search_ops_v2);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`` &` ``演算子を使うことで複雑な条件を指定できます。

```sql
SELECT * FROM memos WHERE content &` 'id >= 2 && (content @ "全文検索" || content @ "MySQL")';
--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

指定したスクリプト`'id >= 2 && (content @ "全文検索" || content @ "MySQL")'`は次のような意味です。

  * `id`は2以上（範囲検索）

  * `content`は`"全文検索"`または`"MySQL"`を含んでいること（全文検索）

スクリプト中では[関数](http://groonga.org/ja/docs/reference/function.html)を使うこともできます。

## シーケンシャルスキャン

シーケンシャルスキャン時にはこの演算子を使うことはできません。
