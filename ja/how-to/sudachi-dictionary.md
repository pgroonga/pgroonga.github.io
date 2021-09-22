---
title: 同義語展開にSudachiの辞書を使う方法
---

## 同義語展開にSudachiの辞書を使う方法

[SudachiDict][sudachi-dict]は同義語辞書を提供しています。PGroongaでこれを使うことができます。

検索システムでSudachiDictにある同義語辞書を使う方法を説明します。ここではSudachiDictにある同義語辞書をシステム辞書として使います。さらに自分たちで定義した同義語辞書も使います。

### SudachiDictにある同義語辞書の内容を登録する方法

SudachiDictベースのシステム同義語辞書のためのテーブルを作る必要があります。ここではこのテーブルの名前は`system_thesaurus`にします。

```sql
CREATE TABLE system_thesaurus (
  term text PRIMARY KEY,
  synonyms text[]
);
```

このテーブルを同義語辞書として使うにはPGroongaのインデックスが必要です。このインデックスでは、同義語のキーとして使う`term`の演算子クラスに`pgroonga_text_term_search_ops_v2`を指定しなければいけません。


```sql
CREATE INDEX system_thesaurus_term_index
  ON system_thesaurus
  USING pgroonga (term pgroonga_text_term_search_ops_v2);
```

SudachiDictにある同義語辞書の中身を`system_thesaurus`に登録するために[Groonga synonym][groonga-synonym]を使います。

Groonga synonymはRubyで書かれています。そのため、事前にRubyをインストールしておかないといけません。

Groonga synonymをインストールします。

```bash
gem install groonga-synonym
```

次のコマンドラインはSudachiDictにある同義語辞書の内容を`system_thesaurus`に登録する`INSERT`を生成します。

```bash
groonga-synonym-generate --format=pgroonga --table=system_thesaurus --output=system_thesaurus_data.sql
```

SudachiDictが関連情報を提供しているので生成されたデータには重みがついています。 

このデータは`psql`内で`\i`を使ってロードできます。

```text
\i system_thesaurus_data.sql
```

### ユーザー同義語辞書の登録方法

ユーザー同義語辞書用のテーブルを作る必要があります。ここでは[同義語グループ][pgroonga-query-expand-usage-synonym-groups]を使います。なぜなら同義語辞書のメンテナンスはコストが高いタスクだからです。同義語グループの方が[単語ごとに同義語を指定する][pgroonga-query-expand-usage-term-to-synonyms]よりもメンテナンスコストが低いです。

ここではこのテーブルの名前を`user_synonym_groups`にします。

```sql
CREATE TABLE user_synonym_groups (
  synonyms text[]
);
```

このテーブルを同義語辞書として使うためにはPGroongaのインデックスが必要です。同義語グループとして使われる`synonyms`には`pgroonga_text_array_term_search_ops_v2`演算子クラスを指定する必要があります。

```sql
CREATE INDEX user_synonym_groups_synonyms_index
          ON user_synonym_groups
       USING pgroonga (synonyms pgroonga_text_array_term_search_ops_v2);
```

以下はサンプルデータです。

```sql
INSERT INTO user_synonym_groups VALUES (ARRAY['pg', 'postgresql']);
```

この同義語グループデータを使うと、`pg`で検索しても`postgresql`で検索しても同じ検索結果になります。`pg`で検索するとクエリーは`pg OR postgresql`になりまうｓ．`postgresql`で検索してもクエリーは`pg OR postgresql`になります。

### 同義語辞書を使った検索方法

これらの同義語辞書を使って検索するために[`pgroonga_query_expand`関数][pgroonga-query-expand]を2回使います。

最初の`pgroonga_query_expand()`はユーザー同義語辞書を使います。

```sql
SELECT
  pgroonga_query_expand(
    'user_synonym_groups',
    'synonyms',
    'synonyms',
    'QUERY'
  );
```

クエリーに`pg`を使った場合の例です。

```sql
SELECT
  pgroonga_query_expand(
    'user_synonym_groups',
    'synonyms',
    'synonyms',
    'pg'
  );
--  pgroonga_query_expand  
-- ------------------------
--  ((pg) OR (postgresql))
-- (1 row)
```

`pg`も`postgresql`も検索されます。

2つめの`pgroonga_query_expand()`は1つめの`pgroonga_query_expand()`の結果に対してシステム同義語辞書を使います。

```sql
SELECT
  pgroonga_query_expand(
    'system_thesaurus',
    'term',
    'synonyms',
    pgroonga_query_expand(
      'user_synonym_groups',
      'synonyms',
      'synonyms',
      'QUERY'
    )
  );
```

ユーザー同義語辞書にもうひとつ同義語グループを追加します。

```sql
INSERT INTO user_synonym_groups VALUES (ARRAY['on-line', 'online']);
```

新しく追加した同義語グループを確認しましょう。

```sql
SELECT
  pgroonga_query_expand(
    'user_synonym_groups',
    'synonyms',
    'synonyms',
    'on-line'
  );
--   pgroonga_query_expand  
-- -------------------------
--  ((on-line) OR (online))
-- (1 row)
```

クエリーに`on-line`を指定してシステム同義語辞書とユーザー同義語辞書を両方使ってみましょう。

```sql
SELECT
  pgroonga_query_expand(
    'system_thesaurus',
    'term',
    'synonyms',
	pgroonga_query_expand(
      'user_synonym_groups',
      'synonyms',
      'synonyms',
      'on-line'
    )
  );
--               pgroonga_query_expand               
-- --------------------------------------------------
--  ((on-line) OR (((>-0.2オンライン) OR (online))))
-- (1 row)
```

この`SELECT`は次のように動きます。

  1. `on-line`はユーザー同義語辞書で`on-line OR online`に展開されます：`on-line` -> `((on-line)) OR (online))`

  2. `online`はシステム同義語辞書で`>-0.2オンライン OR online`に展開されます：`((on-line)) OR (online))` -> `((on-line) OR (((>-0.2オンライン) OR (online))))`

`>-0.2オンライン`の`>-0.2`は`オンライン`の重みを調整しています。この場合、重みは`0.8` (`1 - 0.2`)になります。

全文検索でこれらの同義語辞書を使ってみましょう。

```sql
CREATE TABLE memos (
  content text
);
INSERT INTO memos VALUES ('Online conference is easy to join');
INSERT INTO memos VALUES ('On-line conference is easy to join');
INSERT INTO memos VALUES ('オンライン conference is easy to join');

CREATE INDEX memos_content_index ON memos USING pgroonga (content);

-- For ensuring using index
SET enable_seqscan = no;

SELECT content, pgroonga_score(tableoid, ctid) AS score
  FROM memos
  WHERE
    content &@~
      pgroonga_query_expand(
        'system_thesaurus',
        'term',
        'synonyms',
        pgroonga_query_expand(
          'user_synonym_groups',
          'synonyms',
          'synonyms',
          'on-line'
        )
      );
--                content                |       score       
-- ---------------------------------------+-------------------
--  On-line conference is easy to join    |                 1
--  オンライン conference is easy to join | 0.800000011920929
--  Online conference is easy to join     |                 1
-- (3 rows)
```

[sudachi-dict]:https://github.com/WorksApplications/SudachiDict

[groonga-synonym]:https://github.com/groonga/groonga-synonym

[pgroonga-query-expand-usage-synonym-groups]:../reference/functions/pgroonga-query-expand.html#usage-synonym-groups

[pgroonga-query-expand-usage-term-to-synonyms]:../reference/functions/pgroonga-query-expand.html#usage-term-to-synonyms

[pgroonga-query-expand]:../reference/functions/pgroonga-query-expand.html
