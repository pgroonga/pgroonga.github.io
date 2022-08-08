---
title: pgroonga_query_expand関数
upper_level: ../
---

# `pgroonga_query_expand`関数

1.2.2で追加。

## 概要

`pgroonga_query_expand`関数は[クエリー構文][groonga-query-syntax]を使ったクエリー内にある登録済みの同義語を展開します。クエリー構文は[`&@~`演算子][query-v2]や[`&@~|`演算子][query-in-v2]で使われています。

`pgroonga_query_expand`関数は[クエリー展開][wikipedia-query-expansion]機能を実現するときに便利です。[Groongaのクエリー展開機能のドキュメント][groonga-query-expander]も参照してください。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga_query_expand(table_name,
                           term_column_name,
                           synonyms_column_name,
                           query)
```

`table_name`は`text`型の値です。同義語を格納している既存のテーブルの名前を指定します。

`term_column_name`は`text`型の値です。`table_name`テーブル内の展開対象の単語を格納しているカラムの名前を指定します。このカラムは`text`型か`text[]`型のカラムです。

`synonyms_column_name`は`text`型の値です。`term`カラムの同義語を格納しているカラム名を指定します。このカラムは`text[]`型のカラムです。

`query`は`text`型の値です。[クエリー構文][groonga-query-syntax]を使っているクエリーです。

`pgroonga_query_expand`は`text`型の値を返します。`query`中にある登録済みの同義語がすべて展開されています。

次のように`pgroonga_text_term_search_ops_v2`演算子クラス指定のPGroongaで`${table_name}.${term_column_name}`のインデックスを作成することをオススメします。これは高速にクエリー展開できるようにするためです。

```sql
CREATE TABLE synonyms (
  term text,
  synonyms text[]
);

CREATE INDEX synonyms_term
          ON synonyms
       USING pgroonga (term pgroonga_text_term_search_ops_v2);
```

`pgroonga_query_escape`関数はインデックスなしでも動きますが、インデックスがあるとより高速に動きます。

`btree`のように`text`型の`=`に対応しているインデックスアクセスメソッドであればどのインデックスアクセスメソッドでも使えます。しかし、PGroongaを使うことをオススメします。なぜなら、PGroongaは`text`の値を正規化した`=`（大文字小文字を無視した比較を含む）に対応しているからです。クエリー展開時は値を正規化した`=`が便利です。

## 使い方

次のスタイルを使えます。

  * 1単語を複数の同義語にマッピング

  * 同義語グループ

### 1単語を複数の同義語にマッピング {#usage-term-to-synonyms}

サンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE synonyms (
  term text,
  synonyms text[]
);

CREATE INDEX synonyms_term
          ON synonyms
       USING pgroonga (term pgroonga_text_term_search_ops_v2);

INSERT INTO synonyms VALUES ('PGroonga', ARRAY['PGroonga', 'Groonga PostgreSQL']);
```

このサンプルではPGroongaインデックスを使っているのでクエリー中の`"PGroonga"`も`"pgroonga"`もすべて展開されます。

```sql
SELECT pgroonga_query_expand('synonyms', 'term', 'synonyms',
                             'PGroonga OR Mroonga') AS query_expand;
--                  query_expand                   
-- -------------------------------------------------
--  ((PGroonga) OR (Groonga PostgreSQL)) OR Mroonga
-- (1 row)
SELECT pgroonga_query_expand('synonyms', 'term', 'synonyms',
                             'pgroonga OR mroonga') AS query_expand;
--                   query_expand                   
-- -------------------------------------------------
--  ((PGroonga) OR (Groonga PostgreSQL)) OR mroonga
-- (1 row)
```

### 同義語グループ {#usage-synonym-groups}

2.2.1で追加。

サンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE synonym_groups (
  synonyms text[]
);

CREATE INDEX synonym_groups_synonyms
          ON synonym_groups
       USING pgroonga (synonyms pgroonga_text_array_term_search_ops_v2);

INSERT INTO synonym_groups
  VALUES (ARRAY['PGroonga', 'Groonga']);
```

このサンプルではPGroongaインデックスを使っているのでクエリー中の`"PGroonga"`も`"pgroonga"`もすべて展開されます。

```sql
SELECT pgroonga_query_expand('synonym_groups', 'synonyms', 'synonyms',
                             'PGroonga OR Mroonga') AS query_expand;
--              query_expand             
-- --------------------------------------
--  ((PGroonga) OR (Groonga)) OR Mroonga
-- (1 row)
SELECT pgroonga_query_expand('synonym_groups', 'synonyms', 'synonyms',
                             'pgroonga OR mroonga') AS query_expand;
--              query_expand             
-- --------------------------------------
--  ((PGroonga) OR (Groonga)) OR mroonga
-- (1 row)
```

### 同義語グループを使った検索の具体例

人名テーブルの中から同じ読み方で漢字の異なる人を探すサンプルです。（例：斉藤, 齊藤, 斎藤, 齋藤）

サンプルとなるスキーマとデータは次の通りです。

#### 人名テーブル

```sql
CREATE TABLE names (
  name varchar(255)
);

CREATE INDEX pgroonga_names_index
          ON names
       USING pgroonga (name pgroonga_varchar_full_text_search_ops_v2);

INSERT INTO names
  (name)
  VALUES ('斉藤'),('齊藤'),('斎藤'),('鈴木'),('田中'),('佐藤');
```

#### 同義語テーブル

```sql
CREATE TABLE synonym_groups (
  synonyms text[]
);

CREATE INDEX synonym_groups_synonyms
          ON synonym_groups
       USING pgroonga (synonyms pgroonga_text_array_term_search_ops_v2);

INSERT INTO synonym_groups
  VALUES (ARRAY['斉藤', '齊藤', '斎藤', '齋藤']);
```

このサンプルでは「斉藤」で検索することでnamesテーブル内データの`"斉藤"`も`"齊藤"`も`"斎藤"`もすべて以下のように展開されます。

```sql
SELECT pgroonga_query_expand('synonym_groups', 'synonyms', 'synonyms',
                             '斉藤') AS query_expand;
--              query_expand             
-- --------------------------------------
--   ((斉藤) OR (齊藤) OR (斎藤) OR (齋藤))
-- (1 row)
```


この例では、人名テーブルの検索をするので以下のように検索します。

注意： 下記の例では、検索対象のカラムが`varchar`型なので、`pgroonga_query_expand(...)::varchar`として`pgroonga_query_expand`の結果を明示的にキャストする必要があります。(`pgroonga_query_expand()`の戻り値の型は`text`型なので、検索対象のカラムが`text`型の場合はキャストは不要です。)

このようにキャストしないと、検索対象のカラムと`pgroonga_query_expand()`の型が異なりシーケンシャルサーチになるため、パフォーマンスが出ません。

```sql
SELECT name AS synonym_names from names where name &@~ pgroonga_query_expand(
                             'synonym_groups', 'synonyms', 'synonyms','斉藤')::varchar;
--  synonym_names             
-- -----------------
--      斉藤
--      齊藤
--      斎藤
--(3 rows)
```


## 参考

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&@~|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html

[groonga-query-expander]:http://groonga.org/ja/docs/reference/commands/select.html#select-query-expander

[wikipedia-query-expansion]:https://en.wikipedia.org/wiki/Query_expansion

[query-v2]:../operators/query-v2.html

[query-in-v2]:../operators/query-in-v2.html
