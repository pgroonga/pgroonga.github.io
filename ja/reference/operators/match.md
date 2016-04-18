---
title: "%%演算子"
layout: ja
---

# `%%`演算子

## 概要

`%%`は1つのキーワードで全文検索を実行します。

## 構文

```sql
column %% keyword
```

`column`は検索対象のカラムです。

`keyword`は全文検索で使うキーワードです。`text`型です。

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

`%%`演算子を使うと1つキーワードで全文検索できます。

```sql
SELECT * FROM memos WHERE content %% '全文検索';
--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

複数のキーワードで検索したいときやAND/ORを使った検索をしたいときは[`@@`演算子](query.html)を使います。

## 参考

  * [`@@`演算子](query.html)
