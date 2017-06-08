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

  * [PGroonga対textsearch対pg\_trgm](pgroonga-versus-textsearch-and-pg-trgm.html)

  * [PGroonga対pg\_bigm](pgroonga-versus-pg-bigm.html)

  * [レプリケーション](replication.html)

  * [`jsonb`サポート][jsonb]

## 演算子

### `text`用

#### `pgroonga.text_full_text_search_ops`演算子クラス（デフォルト） {#text-full-text-search-ops}

  * [`ILIKE`演算子][like]

  * `ILIKE`演算子

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 1.2.0から非推奨です。代わりに[`&@`演算子][match-v2]を使ってください。

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 1.2.0から非推奨です。代わりに[`&?`演算子][query-v2]を使ってください。

#### `pgroonga.text_regexp_ops`演算子クラス {#text-regexp-ops}

  * [`ILIKE`演算子][like]

  * `ILIKE`演算子

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

    * 1.2.1から非推奨です。代わりに[`&~`演算子][regular-expression-v2]を使ってください。

### `text[]`用

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 1.2.0から非推奨です。代わりに[`&@`演算子][match-v2]を使ってください。

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 1.2.0から非推奨です。代わりに[`&?`演算子][query-v2]を使ってください。

### `varchar`用

#### `pgroonga.varchar_ops`演算子クラス（デフォルト） {#varchar-ops}

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

#### `pgroonga.varchar_full_text_search_ops`演算子クラス {#varchar-full-text-search-ops}

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 1.2.0から非推奨です。代わりに[`&@`演算子][match-v2]を使ってください。

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 1.2.0から非推奨です。代わりに[`&?`演算子][query-v2]を使ってください。

#### `pgroonga.varchar_regexp_ops`演算子クラス {#varchar-regexp-ops}

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

    * 1.2.1から非推奨です。代わりに[`&~`演算子][regular-expression-v2]を使ってください。

### `varchar[]`用

#### `pgroonga.varchar_array_ops`演算子クラス（デフォルト） {#varchar-array-ops}

  * [`&>`演算子][contain-term-v2]：検索対象の単語の配列に指定した単語が含まれているかをチェック

  * [`%%`演算子][contain-term]：検索対象の単語の配列に指定した単語が含まれているかをチェック

    * 1.2.1から非推奨です。代わりに[`&>`演算子][contain-term-v2]を使ってください。

### 真偽値、数値、タイムスタンプ用

サポートしている型：`boolean`、`smallint`、`integer`、`bigint`、`real`、`double precision`、`timestamp`、`timestamp with time zone`

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

### `jsonb`用

#### `pgroonga.jsonb_ops`演算子クラス（デフォルト） {#jsonb-ops}

  * [`&@` operator][match-jsonb-v2]：`jsonb`内のすべてのテキストデータをキーワード1つで全文検索

  * [`&?`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

  * [`@@`演算子][script-jsonb]：ECMAScriptのようなクエリー言語を使った高度な検索

    * 1.2.1から非推奨です。代わりに[`` &` ``演算子][script-jsonb-v2]を使ってください。

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

## v2演算子

PGroonga 1.Y.Zは`pgroonga.XXX_v2`という演算子クラスを提供します。これらはPGroonga 2.0.0になるまで後方互換性を提供しません。しかし、これらの演算子クラスには新しいバージョンがリリースされるごとに積極的に多くの改良が入ります。

これらを使った場合、PGroongaをアップグレードする場合は[非互換の場合の手順][upgrade-incompatible]を使う必要があります。

### `text`用

#### `pgroonga.text_full_text_search_ops_v2`演算子クラス {#text-full-text-search-ops-v2}

  * [`ILIKE`演算子][like]

  * `ILIKE`演算子

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&~?`演算子][similar-search-v2]：類似文書検索

  * [`` &` ``演算子][script-v2]：ECMAScriptのようなクエリー言語を使った高度な検索 

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

  * [`&@>`演算子][match-in-v2]：キーワードの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@|`演算子][match-in-v2]を使ってください。

  * [`&?|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

  * [`&?>`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&?|`演算子][query-in-v2]を使ってください。

#### `pgroonga.text_term_search_ops_v2`演算子クラス {#text-term-search-ops-v2}

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^>`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

    * 1.2.1から非推奨です。代わりに[`&^|`演算子][prefix-search-in-v2]を使ってください。

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

  * [`&^~>`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

    * 1.2.1から非推奨です。代わりに[`&^~|`演算子][prefix-rk-search-in-v2]を使ってください。

#### `pgroonga.text_regexp_ops_v2`演算子クラス {#text-regexp-ops-v2}

  * [`ILIKE`演算子][like]

  * `ILIKE`演算子

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

### `text[]`用

#### `pgroonga.text_array_full_text_search_ops_v2`演算子クラス {#text-array-full-text-search-ops-v2}

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&~?`演算子][similar-search-v2]：類似文書検索

  * [`` &` ``演算子][script-v2]：ECMAScriptのようなクエリー言語を使った高度な検索 

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

  * [`&@>`演算子][match-in-v2]：キーワードの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@|`演算子][match-in-v2]を使ってください。

  * [`&?|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

  * [`&?>`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&?|`演算子][query-in-v2]を使ってください。

#### `pgroonga.text_array_term_search_ops_v2`演算子クラス {#text-array-term-search-ops-v2}

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^>`演算子][prefix-search-v2]：前方一致検索

    * 1.2.1から非推奨です。代わりに[`&^`演算子][prefix-search-v2]を使ってください。

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^~>`演算子][prefix-rk-search-v2]：前方一致RK検索

    * 1.2.1から非推奨です。代わりに[`&^~`演算子][prefix-rk-search-v2]を使ってください。

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

### `varchar`用

#### `pgroonga.varchar_full_text_search_ops_v2`演算子クラス {#varchar-full-text-search-ops-v2}

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&~?`演算子][similar-search-v2]：類似文書検索

  * [`` &` ``演算子][script-v2]：ECMAScriptのようなクエリー言語を使った高度な検索 

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

  * [`&@>`演算子][match-in-v2]：キーワードの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@|`演算子][query-in-v2]を使ってください。

  * [`&?|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

  * [`&?>`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&?|`演算子][query-in-v2]を使ってください。

#### `pgroonga.varchar_regexp_ops_v2`演算子クラス {#varchar-regexp-ops-v2}

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

### `varchar[]`用

#### `pgroonga.varchar_array_term_search_ops_v2`演算子クラス {#varchar-array-term-search-ops-v2}

  * [`&>`演算子][contain-term-v2]：検索対象の単語の配列に指定した単語が含まれているかをチェック

  * [`%%`演算子][contain-term]：検索対象の単語の配列に指定した単語が含まれているかをチェック

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

### `jsonb`用

#### `pgroonga.jsonb_ops_v2`演算子クラス {#varchar-jsonb-ops-v2}

  * [`&@` operator][match-jsonb-v2]：`jsonb`内のすべてのテキストデータをキーワード1つで全文検索

  * [`&?`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

  * [`@@`演算子][script-jsonb]：ECMAScriptのようなクエリー言語を使った高度な検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

## 関数

  * [`pgroonga.command`関数](functions/pgroonga-command.html)

  * [`pgroonga.command_escape_value`関数](functions/pgroonga-command-escape-value.html)

  * [`pgroonga.escape`関数](functions/pgroonga-escape.html)

  * [`pgroonga.flush`関数](functions/pgroonga-flush.html)

  * [`pgroonga.highlight_html`関数](functions/pgroonga-highlight-html.html)

  * [`pgroonga.match_positions_byte`関数](functions/pgroonga-match-positions-byte.html)

  * [`pgroonga.match_positions_character`関数](functions/pgroonga-match-positions-character.html)

  * [`pgroonga.query_escape`関数](functions/pgroonga-query-escape.html)

  * [`pgroonga.query_extract_keywords`関数](functions/pgroonga-query-extract-keywords.html)

  * [`pgroonga.score`関数](functions/pgroonga-score.html)

  * [`pgroonga.snippet_html`関数](functions/pgroonga-snippet-html.html)

  * [`pgroonga.table_name`関数](functions/pgroonga-table-name.html)

## パラメーター

  * [`pgroonga.enable_wal`パラメーター](parameters/enable-wal.html)

  * [`pgroonga.lock_timeout`パラメーター](parameters/lock-timeout.html)

  * [`pgroonga.log_level`パラメーター](parameters/log-level.html)

  * [`pgroonga.log_path`パラメーター](parameters/log-path.html)

  * [`pgroonga.log_type`パラメーター](parameters/log-type.html)

  * [`pgroonga.query_log_path`パラメーター](parameters/query-log-path.html)

  * [`pgroonga.match_escalation_threshold`パラメーター](parameters/match-escalation-threshold.html)

## モジュール


  * [`pgroonga_check`モジュール](modules/pgroonga-check.html)

## Groongaの関数

[`pgroonga.command`関数](functions/pgroonga-command.html)内で以下のGroongaの関数を使えます。`WHERE`節では使えません。

  * [`pgroonga_tuple_is_alive` Groonga関数](groonga-functions/pgroonga-tuple-is-alive.html)

## チューニング

通常、PGroongaはデフォルトで高速に動くため、特別にPGroongaをチューニングする必要はありません。

しかし、非常に大きなデータベースを扱うなどいくつかのケースではPGroongaをチューニングする必要があります。PGroongaはバックエンドとしてGroongaを使っています。つまり、Groonga用のチューニング知識をPGroongaでも使えるということです。PGroongaをチューニングする場合は以下のGroongaのドキュメントを参照してください。

  * [チューニング](http://groonga.org/ja/docs/reference/tuning.html)

[jsonb]:jsonb.html

[like]:operators/like.html

[match]:operators/match.html
[query]:operators/query.html
[regular-expression]:operators/regular-expression.html

[match-v2]:operators/match-v2.html
[query-v2]:operators/query-v2.html
[match-in-v2]:operators/match-in-v2.html
[query-in-v2]:operators/query-in-v2.html
[regular-expression-v2]:operators/regular-expression-v2.html
[contain-term-v2]:operators/contain-term-v2.html
[contain-term]:operators/contain-term.html
[prefix-search-v2]:operators/prefix-search-v2.html
[prefix-rk-search-v2]:operators/prefix-rk-search-v2.html
[prefix-search-in-v2]:operators/prefix-search-in-v2.html
[prefix-rk-search-in-v2]:operators/prefix-rk-search-in-v2.html
[similar-search-v2]:operators/similar-search-v2.html
[script-v2]:operators/script-v2.html
[match-jsonb-v2]:operators/match-jsonb-v2.html
[query-jsonb-v2]:operators/query-jsonb-v2.html
[script-jsonb-v2]:operators/script-jsonb-v2.html
[script-jsonb]:operators/script-jsonb.html
[contain-jsonb]:operators/contain-jsonb.html

[upgrade-incompatible]:../upgrade/#incompatible-case
