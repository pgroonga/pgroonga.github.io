---
title: "&@演算子"
upper_level: ../
---

# `&@`演算子

1.2.0で追加。

## 概要

`&@`演算子は1つのキーワードで全文検索を実行します。

## 構文

使い方は2つあります。

```sql
column &@ keyword
column &@ (keyword, weights, index_name)::pgroonga_full_text_search_condition
```

前者は後者よりもシンブルです。多くの場合は前者で十分です。

後者は検索スコアーを最適化するときに便利です。たとえば、ブログアプリケーションで「タイトルは本文よりも重要」という検索を実現できます。

後者は2.0.4から使えます。

以下は前者の使い方の説明です。

```sql
column &@ keyword
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`keyword`は全文検索で使うキーワードです。`column`が`text`型または`text[]`型なら`keyword`は`text`型です。`column`が`varchar`型なら`keyword`は`varchar`型です。

以下は後者の使い方の説明です。

```sql
column &@ (keyword, weights, index_name)::pgroonga_full_text_search_condition
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`keyword`は全文検索で使うキーワードです。`column`が`text`型または`text[]`型なら`keyword`は`text`型です。`column`が`varchar`型なら`keyword`は`varchar`型です。

`weights`はそれぞれの値の重要度です。`int[]`型です。もし、`column`が`text`型か`varchar`型なら、最初の要素がカラムの値の重要度になります。`column`が`text[]`型なら、同じ位置の値がその値の重要度になります。

`weights`を`NULL`にできます。`weights`の要素も`NULL`にできます。対応する重要度が`NULL`の場合は重要度は`1`になります。

重要度が`0`の場合は対応する値を無視します。たとえば、`ARRAY[1, 0, 1]`は2番目の値は検索しないという意味になります。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

`index_name` can be `NULL`.

これはシーケンシャルサーチのときにもPGroongaのインデックスに指定した検索オプションを使えるようにするために使われます。

未実装です。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_full_text_search_ops_v2`：`text`型のデフォルト

  * `pgroonga_text_array_full_text_search_ops_v2`：`text[]`型のデフォルト

  * `pgroonga_varchar_full_text_search_ops_v2`：`varchar`用

  * `pgroonga_text_full_text_search_ops`：`text`用

  * `pgroonga_text_array_full_text_search_ops`：`text[]`用

  * `pgroonga_varchar_full_text_search_ops`：`varchar`用

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

`&@`演算子を使うと1つキーワードで全文検索できます。

```sql
SELECT * FROM memos WHERE content &@ '全文検索';
--  id |                      content                      
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

「タイトルは本文よりも重要」も実現できます。

例に使うサンプルスキーマとデータは次の通りです。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING PGroonga ((ARRAY[title, content]));
```

```sql
INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES ('Groonga', 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES ('PGroonga', 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES ('コマンドライン', 'groongaコマンドがあります。');
```

[`pgroonga_score`関数][score]を使うと「`Groonga`」により適したレコードを見つけられます。

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@
       ('Groonga',
        ARRAY[5, 1],
        'pgroonga_memos_index')::pgroonga_full_text_search_condition
 ORDER BY score DESC;
--      title      |                                  content                                  | score 
-- ----------------+---------------------------------------------------------------------------+-------
--  Groonga        | Groongaは日本語対応の高速な全文検索エンジンです。                         |     6
--  PGroonga       | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。 |     1
--  コマンドライン | groongaコマンドがあります。                                               |     1
-- (3 rows)
```

`content`カラムに「`Groonga`」を含むレコードよりも、`title`カラムに「`Groonga`」を含むレコードのほうが高いスコアになっています。

2番目の重みの値に`0`を指定すると`content`カラムを無視できます。

```sql
SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM memos
 WHERE ARRAY[title, content] &@
       ('Groonga',
        ARRAY[5, 0],
        'pgroonga_memos_index')::pgroonga_full_text_search_condition
 ORDER BY score DESC;
--   title  |                      content                      | score 
-- ---------+---------------------------------------------------+-------
--  Groonga | Groongaは日本語対応の高速な全文検索エンジンです。 |     5
-- (1 row)
```

複数のキーワードで全文検索したいときやAND/ORを使った検索をしたいときは[`&@~`演算子][query-v2]を使います。

複数のキーワードでOR全文検索をしたいときは[`&@|`演算子][match-in-v2]を使います。

## 参考

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

[query-v2]:query-v2.html
[match-in-v2]:match-in-v2.html

[score]:../functions/pgroonga-score.html
