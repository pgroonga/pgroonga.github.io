---
title: LIKE演算子
layout: ja
---

# `LIKE`演算子

PGroongaは内部的に`column LIKE '%キーワード%'`条件を`column %% 'キーワード'`条件に変換します。[`%%`演算子](match.html)はインデックスを使って全文検索をします。これはインデックスを使わない`LIKE`演算子より速いです。

最初の`%`と最後の`%`はどちらも重要です。`'キーワード%'`、`'%キーワード'`などは`column %% 'キーワード'`に変換されます。このようなパターンを指定するとPGroongaは1件もレコードを返しません。なぜならPGroongaはインデックスなしではこれらのパターンを検索できないからです。

元の`LIKE`演算子は対象テキストに対して検索します。しかし、`%%`演算子は正規化したテキストに対して検索します。これは、インデックスを使った`LIKE`演算子の検索結果と、元の`LIKE`演算子の検索結果は異なるということです。

たとえば、元の`LIKE`演算子は大文字小文字を区別して検索します。しかし、インデックスを使った`LIKE`演算子は大文字小文字を区別しません。

元の`LIKE`演算子の結果です。

```sql
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;
SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |           content           
-- ----+-----------------------------
--   4 | groongaコマンドがあります。
-- (1 行)
```

インデックスを使った`LIKE`演算子の結果です。

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;
SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   4 | groongaコマンドがあります。
-- (3 行)
```

インデックスを使った`LIKE`演算子の結果と元の`LIKE`演算子の結果を同じにしたい場合は次のトークナイザーとノーマライザーを使います。

  * トークナイザー: `TokenBigramSplitSymbolAlphaDigit`
  * ノーマライザー: なし

具体例は次の通りです。

```sql
CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenBigramSplitSymbolAlphaDigit',
              normalizer='');
```

元の`LIKE`演算子とインデックスを使った`LIKE`演算子で同じ結果が返ります。

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;
SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |           content           
-- ----+-----------------------------
--   4 | groongaコマンドがあります。
-- (1 行)
```

通常、デフォルトの設定は元の`LIKE`演算子よりも適切な全文検索結果を返す設定です。もし、デフォルトの設定をするときは、変更する前にユーザーにとてどのような結果が適切かを考えてください。

トークナイザーとノーマライザーをカスタマイズする方法については[`CREATE INDEX USING pgroonga`のカスタマイズ](../create-index-using-pgroonga.html#customization)を参照してください。
