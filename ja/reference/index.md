---
title: リファレンスマニュアル
layout: ja
---

# リファレンスマニュアル

このドキュメントはすべての機能を説明しています。[チュートリアル](../tutorial/)は重要な機能だけを簡単に理解できることに注力しています。このドキュメントは完全に説明することに注力しています。もし、まだ[チュートリアル](../tutorial/)を読んでいない場合は、このドキュメントを読む前にチュートリアルを読んでください。

## `pgroonga`スキーマ

PGroongaは`pgroonga`スキーマに関数・演算子・演算子クラスなどを定義します。デフォルトではスーパーユーザーしか`pgroonga`スキーマの機能を使えません。スーパーユーザーはPGroongaを使いたいすべての一般ユーザーに`pgroonga`スキーマの`USAGE`権限を与えなければいけません。

  * [`GRANT USAGE ON SCHEMA pgroonga`](grant-usage-on-schema-pgroonga.html)

## `pgroonga`インデックス

  * [`CREATE INDEX USING pgroonga`](create-index-using-pgroonga.html)

  * [PGroonga対GiSTとGIN](pgroonga-versus-gist-and-gin.html)

  * [`jsonb`サポート](jsonb.html)

## 演算子

  * [`LIKE`演算子](operators/like.html)

  * `ILIKE`演算子

  * [`%%`演算子](operators/match.html)

  * `jsonb`型以外の型用の[`@@`演算子](operators/query.html)

  * `jsonb`型用の[`@@`演算子](operators/jsonb-query.html)

  * [`@>`演算子](operators/jsonb-contain.html)

  * [`@~`演算子](operators/regular-expression.html)

## 関数

  * [`pgroonga.score`関数](functions/pgroonga-score.html)

  * [`pgroonga.command`関数](functions/pgroonga-command.html)

  * [`pgroonga.table_name`関数](functions/pgroonga-table-name.html)

  * [`pgroonga.snippet_html`関数](functions/pgroonga-snippet-html.html)

## パラメーター

  * [`pgroonga.log_type`パラメーター](parameters/log_type.html)

  * [`pgroonga.log_path`パラメーター](parameters/log_path.html)

  * [`pgroonga.log_level`パラメーター](parameters/log_level.html)

  * [`pgroonga.lock_timeout`パラメーター](parameters/lock_timeout.html)

## チューニング

通常、PGroongaはデフォルトで高速に動くため、特別にPGroongaをチューニングする必要はありません。

しかし、非常に大きなデータベースを扱うなどいくつかのケースではPGroongaをチューニングする必要があります。PGroongaはバックエンドとしてGroongaを使っています。つまり、Groonga用のチューニング知識をPGroongaでも使えるということです。PGroongaをチューニングする場合は以下のGroongaのドキュメントを参照してください。

  * [チューニング](http://groonga.org/ja/docs/reference/tuning.html)
