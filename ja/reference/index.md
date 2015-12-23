---
title: リファレンスマニュアル
layout: ja
---

# リファレンスマニュアル

このドキュメントはすべての機能を説明しています。[チュートリアル](../tutorial/)は重要な機能だけを簡単に理解できることに注力しています。このドキュメントは完全に説明することに注力しています。もし、まだ[チュートリアル](../tutorial/)を読んでいない場合は、このドキュメントを読む前にチュートリアルを読んでください。

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

  * `@~`演算子

## 関数

  * [`pgroonga.score`関数](functions/pgroonga-score.html)

  * [`pgroonga.command`関数](functions/pgroonga-command.html)

  * [`pgroonga.table_name`関数](functions/pgroonga-table-name.html)

## 実行時パラメータ

  * [`pgroonga.log_type`](parameters/log_type.html)
  * [`pgroonga.log_path`](parameters/log_path.html)
  * [`pgroonga.log_level`](parameters/log_level.html)
  * [`pgroonga.lock_timeout`](parameters/lock_timeout.html)
