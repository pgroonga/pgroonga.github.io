---
title: LIKE operator
layout: en
---

# `LIKE` operator

TODO

なお、`'キーワード%'`や`'%キーワード'`のように最初と最後に`%`がついて
いない場合は必ず検索結果が空になります。このようなパターンはインデック
スを使って検索できないからです。気をつけてください。

本来の`LIKE`演算子は元の文字列そのものに対して検索しますが、`@@`演算子
は正規化後の文字列に対して全文検索検索を実行します。そのため、インデッ
クスを使わない場合の`LIKE`演算子の結果（本来の`LIKE`演算子の結果）とイ
ンデックスを使った場合の`LIKE`演算子の結果は異なります。

たとえば、本来の`LIKE`演算子ではアルファベットの大文字小文字を区別した
りいわゆる全角・半角を区別しますが、インデックスを使った場合は区別なく
検索します。



本来の`LIKE`演算子の結果:

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

インデックスを使った`LIKE`演算子の結果:

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

インデックスを使った場合でも本来の`LIKE`演算子と同様の結果にしたい場合
は次のようにトークナイザー（後述）とノーマライザー（後述）を設定してイ
ンデックスを作成してください。

  * トークナイザー: `TokenBigramSplitSymbolAlphaDigit`
  * ノーマライザー: なし

具体的には次のようにインデックスを作成します。

```sql
CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenBigramSplitSymbolAlphaDigit',
              normalizer='');
```

このようなインデックスを作っているときはインデックスを使った`LIKE`演算
子でも本来の`LIKE`演算子と同様の挙動になります。

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

多くの場合、デフォルトの設定の全文検索結果の方が本来の`LIKE`演算子の方
の検索結果よりもユーザーが求めている結果に近くなります。本当に本来の
`LIKE`演算子の挙動の方が適切か検討した上で使ってください。

