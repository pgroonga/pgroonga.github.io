---
title: 同義語検索の方法
---

## 同義語検索の方法

同義語を検索するためには、同義語を登録するテーブルを新規に作成する必要があります。

同義語を登録するテーブルの作成方法、同義語の登録、削除、更新、同義語の検索方法について説明します。

### 同義語を登録するテーブルの作成方法

以下のように同義語を登録するテーブルを作成します。

```sql
CREATE TABLE synonyms (
  term text PRIMARY KEY,
  synonyms text[]
);

CREATE INDEX synonyms_search ON synonyms USING pgroonga (term pgroonga.text_term_search_ops_v2);
```

`term`に登録した後をキーに、`synonyms`に登録した語を取得します。

例えば、「ウィンドウ」を検索キーワードに指定した時に、「ディスプレイ」もマッチしてほしい場合、「ウィンドウ」を`term`に登録し、「ウィンドウ」と「ディスプレイ」を`synonyms`に登録します。(同義語対象の語も`synonyms`へ登録する必要があることに注意してください。)

`term`は大文字、小文字を区別せず高速に検索できるようにするため、PGroongaのインデックスを設定しています。

`synonyms`は`text[]`型のカラムなので、複数の同義語を登録できます。

### 同義語の登録

同義語は、`synonyms`にデータを挿入することで登録できます。

例えば、「ウィンドウ」と「ディスプレイ」と「ビデオディスプレイ」を同義語として登録したい場合、以下のようにこれらの後を同義語を登録するためのテーブルへ挿入します。

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('ウィンドウ', ARRAY['ウィンドウ', 'ディスプレイ', 'ビデオディスプレイ']);
INSERT INTO synonyms (term, synonyms) VALUES ('ディスプレイ', ARRAY['ディスプレイ', 'ウィンドウ', 'ビデオディスプレイ']);
INSERT INTO synonyms (term, synonyms) VALUES ('ビデオディスプレイ', ARRAY['ビデオディスプレイ', 'ウィンドウ', 'ディスプレイ']);
```

### 同義語の追加

同義語の追加は3つのパターンがあります。それぞれのパターンについて追加方法を説明します。

#### 新しい同義語の追加

同義語の登録と同じ方法で、同義語の追加ができます。例えば「レプリカ」と「シミュレート」と「コピー」を同義語として追加したい場合、以下のようにこれらの語を同義語登録用のテーブルへ挿入します。

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('コピー', ARRAY['コピー', 'レプリカ', 'シミュレート']);
INSERT INTO synonyms (term, synonyms) VALUES ('レプリカ', ARRAY['レプリカ', 'コピー', 'シミュレート']);
INSERT INTO synonyms (term, synonyms) VALUES ('シミュレート', ARRAY['シミュレート', 'コピー', 'レプリカ']);
```

### 既に存在する同義語に新たに同義語を追加する

既に存在する同義語に新たな同義語を追加したい場合は、既存のレコードを更新します。例えば、検索キーワードに「コピー」を使った時に、「偽物」もマッチしてほしい場合。

```sql
UPDATE synonyms SET synonyms = array_append(synonyms, '偽物') WHERE term = 'コピー';
UPDATE synonyms SET synonyms = array_append(synonyms, '偽物') WHERE term = 'レプリカ';
UPDATE synonyms SET synonyms = array_append(synonyms, '偽物') WHERE term = 'シミュレート';
```

「偽物」は新しい同義語なので、以下のように`INSERT`を使って`synonyms`にレコードを追加します。

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('偽物', ARRAY['偽物', 'コピー', 'レプリカ', 'シミュレート']);
```

#### 既にある同義語の修正

既に存在するレコードを修正したい場合は、それらを更新します。例えば、「ウィンドウ」を「ウインドウ」に修正したい場合、以下のようにします。

```sql
UPDATE synonyms SET synonyms = array_append(array_remove(synonyms, 'ウインドウ'), 'ウィンドウ') WHERE term = 'ディスプレイ';
UPDATE synonyms SET synonyms = array_append(array_remove(synonyms, 'ウインドウ'), 'ウィンドウ') WHERE term = 'ビデオディスプレイ';
UPDATE synonyms SET synonyms = array_append(array_remove(synonyms, 'ウインドウ'), 'ウィンドウ') WHERE term = 'ウインドウ';
UPDATE synonyms SET synonyms = array_append(array_remove(term, 'ウインドウ'), 'ウィンドウ') WHERE term = 'ウインドウ';
```

#### 同義語の削除

同義語を削除したい場合は、`synonyms`からレコードを削除します。例えば、synonymsから「ウィンドウ」を削除したい場合は、以下のようにします。

```sql
UPDATE synonyms SET synonyms = array_remove(synonyms, 'ウィンドウ') WHERE term = 'ディスプレイ';
UPDATE synonyms SET synonyms = array_remove(synonyms, 'ウィンドウ') WHERE term = 'ビデオディスプレイ';
DELETE synonyms WHERE term = 'ウィンドウ';
```

### 同義語検索の方法

同義語の検索には、[`pgroonga_query_expand`関数](../reference/functions/pgroonga-query-expand.html)を使います。

詳細は[`pgroonga_query_expand`関数](../reference/functions/pgroonga-query-expand.html)を参照してください。

例えば、「ウィンドウ」の同義語を検索する場合、以下のようにします。

第一に、同義語テーブルを作成します。

```sql
CREATE TABLE synonyms (
  term text PRIMARY KEY,
  synonyms text[]
);

CREATE INDEX synonyms_search ON synonyms USING pgroonga (term pgroonga.text_term_search_ops_v2);
```

第二に、同義語を同義語テーブルへ登録します。

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('ウィンドウ', ARRAY['ウィンドウ', 'ディスプレイ', 'ビデオディスプレイ']);
INSERT INTO synonyms (term, synonyms) VALUES ('ディスプレイ', ARRAY['ディスプレイ', 'ウィンドウ', 'ビデオディスプレイ']);
INSERT INTO synonyms (term, synonyms) VALUES ('ビデオディスプレイ', ARRAY['ビデオディスプレイ', 'ウィンドウ', 'ディスプレイ']);
```

第三に、同義語検索を実行します。

```sql
CREATE TABLE memos (
  id integer,
  content text
);
INSERT INTO memos VALUES (1, 'PC用のウィンドウがとても安い！');
INSERT INTO memos VALUES (2, '高品質のビデオディスプレイが安い！');
INSERT INTO memos VALUES (3, 'これは、ジャンク品のディスプレイです。');

CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);

SELECT * FROM memos
  WHERE
    content &@~
      pgroonga_query_expand('synonyms', 'term', 'synonyms', 'Window');

 id |                content                 
----+----------------------------------------
  1 | PC用のウィンドウがとても安い！
  2 | 高品質なビデオディスプレイが安い！
  3 | これは、ジャンク品のディスプレイです。
(3 rows)
```

