---
title: リファレンスマニュアル
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

### v2演算子

PGroonga 1.Y.Zは`pgroonga.XXX_v2`という演算子クラスを提供します。これらはPGroonga 2.0.0になるまで後方互換性を提供しません。しかし、これらの演算子クラスには新しいバージョンがリリースされるごとに積極的に多くの改良が入ります。

これらを使った場合、PGroongaをアップグレードする場合は[非互換の場合の手順](../upgrade/#incompatible-case)を使う必要があります。

  * `pgroonga.text_full_text_search_ops_v2`演算子クラス

    * `LIKE`演算子

    * `ILIKE`演算子

    * [`&@`演算子](operators/match-v2.html)

    * `jsonb`型以外の型用の[`&?`演算子](operators/query-v2.html)

    * [`&~?`演算子](operators/similar-search-v2.html)

    * [`` &` ``演算子](operators/script-v2.html)

    * [`&@>`演算子](operators/match-contain-v2.html)

    * `jsonb`型以外の型用の[`&?>`演算子](operators/query-contain-v2.html)

  * `pgroonga.text_term_search_ops_v2`演算子クラス

    * [`&^`演算子](operators/prefix-search-v2.html)

    * [`&^~`演算子](operators/prefix-rk-search-v2.html)

  * `pgroonga.text_array_term_search_ops_v2`演算子クラス

    * [`&^>`演算子](operators/prefix-search-contain-v2.html)

    * [`&^~>`演算子](operators/prefix-rk-search-contain-v2.html)

## 関数

  * [`pgroonga.score`関数](functions/pgroonga-score.html)

  * [`pgroonga.command`関数](functions/pgroonga-command.html)

  * [`pgroonga.table_name`関数](functions/pgroonga-table-name.html)

  * [`pgroonga.snippet_html`関数](functions/pgroonga-snippet-html.html)

  * [`pgroonga.highlight_html`関数](functions/pgroonga-highlight-html.html)

  * [`pgroonga.match_positions_byte`関数](functions/pgroonga-match-positions-byte.html)

  * [`pgroonga.match_positions_character`関数](functions/pgroonga-match-positions-character.html)

  * [`pgroonga.query_extract_keywords`関数](functions/pgroonga-query-extract-keywords.html)

## パラメーター

  * [`pgroonga.log_type`パラメーター](parameters/log_type.html)

  * [`pgroonga.log_path`パラメーター](parameters/log_path.html)

  * [`pgroonga.log_level`パラメーター](parameters/log_level.html)

  * [`pgroonga.lock_timeout`パラメーター](parameters/lock_timeout.html)

  * [`pgroonga.enable_wal`パラメーター](parameters/enable_wal.html)

## Groongaの関数

[`pgroonga.command`関数](functions/pgroonga-command.html)内で以下のGroongaの関数を使えます。`WHERE`節では使えません。

  * [`pgroonga_tuple_is_alive` Groonga関数](groonga-functions/pgroonga-tuple-is-alive.html)

## チューニング

通常、PGroongaはデフォルトで高速に動くため、特別にPGroongaをチューニングする必要はありません。

しかし、非常に大きなデータベースを扱うなどいくつかのケースではPGroongaをチューニングする必要があります。PGroongaはバックエンドとしてGroongaを使っています。つまり、Groonga用のチューニング知識をPGroongaでも使えるということです。PGroongaをチューニングする場合は以下のGroongaのドキュメントを参照してください。

  * [チューニング](http://groonga.org/ja/docs/reference/tuning.html)
