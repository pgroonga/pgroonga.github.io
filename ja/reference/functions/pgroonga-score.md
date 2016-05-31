---
title: pgroonga.score関数
---

# `pgroonga.score`関数

## 概要

`pgroonga.score`関数はマッチした度合いを数値で返します。もし、検索したクエリーに対してそのレコードがマッチしているほどそのレコードのスコアーは高い数値になります。

## 構文

`pgroonga.score`関数を使うとマッチした度合いを数値で取得することができます。検索したクエリーに対してよりマッチしているレコードほど高い数値になります。

```text
double precision pgroonga.score(record)
```

`record`はテーブル名です。

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
SELECT *, pgroonga.score(score_memos)
  FROM score_memos
 WHERE content %% 'PGroonga';
```

`pgroonga.score`関数は`double precision`型の値でマッチした度合いを返します。

## 使い方

`pgroonga.score`関数を使うには、`pgroonga`インデックスにプライマリーキーに指定したカラムを追加する必要があります。もし、プライマリーキーに指定したカラムを`pgroonga`インデックスに追加していない場合は、`pgroonga.score`関数は常に`0.0`を返します。

`pgroonga.score`関数はインデックスを使わずに全文検索した場合は常に`0.0`を返します。言い換えると、`pgroonga.score`関数はシーケンシャルスキャンで全文検索を実行した場合は常に`0.0`を返します。

もし、`pgroonga.score`関数が意図せずに`0.0`を返しているときは、次のことを確認してください。

  * プライマリーキーに指定しているカラムがPGroongaのインデックス対象に含まれているかどうか
  * インデックスを使って全文検索されているかどうか

現在のところ、スコアーの値は「何個キーワードが含まれていたか」（TF、Term Frequency）です。Groongaはどのようにスコアーを計算するかをカスタマイズすることができます。しかし、PGroongaはまだその機能をサポートしていません。

## 使い方

[チュートリアルの中の例](../../tutorial/#score)を参考にしてください。

## 参考

  * [チュートリアルの中の例](../../tutorial/#score)
