---
title: pgroonga.query_expand関数
upper_level: ../
---

# `pgroonga.query_expand`関数

1.2.2で追加。

## 概要

`pgroonga.query_expand`関数は[クエリー構文][groonga-query-syntax]を使ったクエリー内にある登録済みの同義語を展開します。クエリー構文は[`&@~`演算子][query-v2]や[`&@~|`演算子][query-in-v2]で使われています。

`pgroonga.query_expand`関数は[クエリー展開][wikipedia-query-expansion]機能を実現するときに便利です。[Groongaのクエリー展開機能のドキュメント][groonga-query-expander]も参照してください。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.query_expand(table_name,
                           term_column_name,
                           synonyms_column_name,
                           query)
```

`table_name`は`text`型の値です。同義語を格納している既存のテーブルの名前を指定します。

`term_column_name`は`text`型の値です。`table_name`テーブル内の展開対象の単語を格納しているカラムの名前を指定します。このカラムは`text`型のカラムです。

`synonyms_column_name`は`text`型の値です。`term`カラムの同義語を格納しているカラム名を指定します。このカラムは`text[]`型のカラムです。

`query`は`text`型の値です。[クエリー構文][groonga-query-syntax]を使っているクエリーです。

`pgroonga.query_expand`は`text`型の値を返します。`query`中にある登録済みの同義語がすべて展開されています。

次のように`pgroonga.text_term_search_ops_v2`演算子クラス指定のPGroongaで`${table_name}.${term_column_name}`のインデックスを作成することをオススメします。これは高速にクエリー展開できるようにするためです。

```sql
CREATE TABLE synonyms (
  term text,
  synonyms text[]
);

CREATE INDEX synonyms_term
          ON synonyms
       USING pgroonga (term pgroonga.text_term_search_ops_v2);
```

`pgroonga.query_escape`関数はインデックスなしでも動きますが、インデックスがあるとより高速に動きます。

`btree`のように`text`型の`=`に対応しているインデックスアクセスメソッドであればどのインデックスアクセスメソッドでも使えます。しかし、PGroongaを使うことをオススメします。なぜなら、PGroongaは`text`の値を正規化した`=`（大文字小文字を無視した比較を含む）に対応しているからです。クエリー展開時は値を正規化した`=`は便利です。

## 使い方

サンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE synonyms (
  term text,
  synonyms text[]
);

CREATE INDEX synonyms_term
          ON synonyms
       USING pgroonga (term pgroonga.text_term_search_ops_v2);

INSERT INTO synonyms VALUES ('PGroonga', ARRAY['PGroonga', 'Groonga PostgreSQL']);
```

このサンプルではPGroongaインデックスを使っているのでクエリー中の`"PGroonga"`も`"pgroonga"`もすべて展開されます。

```sql
SELECT pgroonga.query_expand('synonyms', 'term', 'synonyms',
                             'PGroonga OR Mroonga');
--                  query_expand                   
-- -------------------------------------------------
--  ((PGroonga) OR (Groonga PostgreSQL)) OR Mroonga
-- (1 row)
SELECT pgroonga.query_expand('synonyms', 'term', 'synonyms',
                             'pgroonga OR mroonga');
--                   query_expand                   
-- -------------------------------------------------
--  ((PGroonga) OR (Groonga PostgreSQL)) OR mroonga
-- (1 row)
```

## 参考

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&@~|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html

[groonga-query-expander]:http://groonga.org/ja/docs/reference/commands/select.html#select-query-expander

[wikipedia-query-expansion]:https://en.wikipedia.org/wiki/Query_expansion

[query-v2]:../operators/query-v2.html

[query-in-v2]:../operators/query-in-v2.html
