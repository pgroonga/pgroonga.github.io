---
title: pgroonga_score関数
upper_level: ../
---

# `pgroonga_score`関数

## 概要

`pgroonga_score`関数はマッチした度合いを数値で返します。もし、検索したクエリーに対してそのレコードがマッチしているほどそのレコードのスコアーは高い数値になります。

## 構文

`pgroonga_score`関数を使うとマッチした度合いを数値で取得することができます。検索したクエリーに対してよりマッチしているレコードほど高い数値になります。

使い方は2つあります。

```text
double precision pgroonga_score(tableoid, ctid)
double precision pgroonga_score(record)
```

前者は2.0.4以降で利用できます。後者よりも速いです。

後者は2.0.4以降は非推奨になりました。

以下は前者の使い方の説明です。

```text
double precision pgroonga_score(tableoid, ctid)
```

`tableoid`はテーブルのOIDです。このパラメーターには`tableoid`[システムカラム][postgresql-system-columns]を指定してください。

`ctid`は対象行のIDです。このパラメーターには`ctid`[システムカラム][postgresql-system-columns]を指定してください。

この使い方ではPGroongaのインデックスにプライマリーキーを追加する必要はありません。

次のスキーマが定義されているとします。

```sql
CREATE TABLE score_memos (
  content text
);

CREATE INDEX pgroonga_score_memos_content_index
          ON score_memos
       USING pgroonga (content);
```

この`pgroonga_score`の使い方は次のようになります。

```sql
SELECT *, pgroonga_score(tableoid, ctid)
  FROM score_memos
 WHERE content &@~ 'PGroonga';
```

`pgroonga_score`関数は`double precision`型の値でマッチした度合いを返します。

以下は後者の使い方の説明です。

```text
double precision pgroonga_score(record)
```

`record`はテーブル名です。

この使い方の`pgroonga_score`ではPGroongaのインデックスにプライマリーキーを追加する必要があります。

次のスキーマが定義されているとします。

```sql
CREATE TABLE score_memos (
  id integer PRIMARY KEY,
  content text
);

CREATE INDEX pgroonga_score_memos_content_index
          ON score_memos
       USING pgroonga (id, content);
```

`record`は`score_memos`にします。

```sql
SELECT *, pgroonga_score(score_memos)
  FROM score_memos
 WHERE content&@~ 'PGroonga';
```

`pgroonga_score`関数は`double precision`型の値でマッチした度合いを返します。

## 使い方

`pgroonga_score(record)`版を使う場合はPGroongaのインデックスにプライマリーキーを追加する必要があります。PGroongaのインデックスにプライマリーキーを指定していない場合は、`pgroonga_score`関数は常に`0.0`を返します。

`pgroonga_score(tableoid, ctid)`版を使う場合は、PGroongaのインデックスにプライマリーキーを追加する必要はありません。

`pgroonga_score`関数はインデックスを使わずに全文検索した場合は常に`0.0`を返します。言い換えると、`pgroonga_score`関数はシーケンシャルスキャンで全文検索を実行した場合は常に`0.0`を返します。

もし、`pgroonga_score`関数が意図せずに`0.0`を返しているときは、次のことを確認してください。

  * プライマリーキーに指定しているカラムがPGroongaのインデックス対象に含まれているかどうか
  * インデックスを使って全文検索されているかどうか

現在のところ、スコアーの値は「何個キーワードが含まれていたか」（TF、Term Frequency）です。Groongaはどのようにスコアーを計算するかをカスタマイズすることができます。しかし、PGroongaはまだその機能をサポートしていません。

[チュートリアルの中の例][tutorial-score]を参考にしてください。

## 参考

  * [チュートリアルの中の例][tutorial-score]

[postgresql-system-columns]:{{ site.postgresql_doc_base_url.en }}/ddl-system-columns.html

[tutorial-score]:../../tutorial/#score
