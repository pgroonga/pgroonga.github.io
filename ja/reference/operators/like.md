---
title: LIKE演算子
upper_level: ../
---

# `LIKE`演算子

## 概要

PGroongaは内部的に`column LIKE '%キーワード%'`条件を`column %% 'キーワード'`条件に変換します。[`%%`演算子](match.html)はインデックスを使って全文検索をします。これはインデックスを使わない`LIKE`演算子より速いです。

インデックスを使った`column LIKE '%キーワード%'`は`column %% 'キーワード'`よりも遅いです。これは、インデックスを使った`column LIKE '%キーワード%'`は「[再検査]({{ site.postgresql_doc_base_url.ja }}/index-scanning.html)」する必要があるからです。`column %% 'キーワード'`は「再検査」する必要がありません。

元の`LIKE`演算子は対象テキストに対して検索します。しかし、`%%`演算子は正規化したテキストに対して検索します。そのため、インデックスを使って`LIKE`演算子の検索を実行した場合は「再検査」が必要になります。


## 構文

この演算子の構文は次の通りです。

```sql
column LIKE pattern
```

`column`は検索対象のカラムです。

`pattern`は検索パターンです。`text`型です。

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

インデックスを使って`LIKE`演算子を実行できます。

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%groonga%';
--  id |           content           
-- ----+-----------------------------
--   4 | groongaコマンドがあります。
-- (1 row)
```

PGroongaのインデックスが適用している`text`型用のデフォルトのオペレータークラスは、キーワードがアルファベットのみだった場合、キーワードの一部だけで検索してもヒットしません。たとえば、`roonga`というキーワードではヒットしません。

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id | content 
-- ----+---------
-- (0 rows)
```

インデックスを使わない場合は`roonga`というキーワードでもヒットします。

```sql
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   4 | groongaコマンドがあります。
-- (3 rows)
```

キーワードがアルファベットだけだった場合でも、`Gro`のようにキーワードの先頭部分を指定した場合はヒットします。

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%Gro%';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
-- (2 rows)
```

キーワードがアルファベットの場合でも、キーワードの一部で検索できるようにする方法は2つあります。

最初の方法は`TokenBigramSplitSymbolAlphaDigit`トークナイザーを使う方法です。

```sql
DROP INDEX IF EXISTS pgroonga_content_index;

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenBigramSplitSymbolAlphaDigit');
```

これで`roonga`でもヒットするようになります。

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   4 | groongaコマンドがあります。
-- (3 rows)
```

トークナイザーをカスタマイズする方法については[`CREATE INDEX USING pgroonga`のカスタマイズ](../create-index-using-pgroonga.html#customization)を参照してください。

2つめの方法は`pgroonga.text_regexp_ops`オペレータークラスを使う方法です。

```sql
DROP INDEX IF EXISTS pgroonga_content_index;

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content pgroonga.text_regexp_ops);
```

これで`roonga`でもヒットするようになります。

```sql
SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = on;

SELECT * FROM memos WHERE content LIKE '%roonga%';
--  id |                                  content                                  
-- ----+---------------------------------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   4 | groongaコマンドがあります。
-- (3 rows)
```

## 参考

  * [`CREATE INDEX USING pgroonga`](../create-index-using-pgroonga.html)

