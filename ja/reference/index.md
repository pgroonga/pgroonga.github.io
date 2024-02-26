---
title: リファレンスマニュアル
upper_level: ../
---

# リファレンスマニュアル

このドキュメントはすべての機能を説明しています。[チュートリアル](../tutorial/)は重要な機能だけを簡単に理解できることに注力しています。このドキュメントは完全に説明することに注力しています。もし、まだ[チュートリアル](../tutorial/)を読んでいない場合は、このドキュメントを読む前にチュートリアルを読んでください。

## `pgroonga`スキーマ

`pgroonga`スキーマは2.0.0から非推奨です。新しく書くコードでは`pgroonga`スキーマではなくカレントスキーマに定義されている`pgroonga_*`関数・演算子・演算子クラスを使ってください。

PGroongaは`pgroonga`スキーマに関数・演算子・演算子クラスなどを定義します。デフォルトではスーパーユーザーしか`pgroonga`スキーマの機能を使えません。スーパーユーザーはPGroongaを使いたいすべての一般ユーザーに`pgroonga`スキーマの`USAGE`権限を与えなければいけません。

  * [`GRANT USAGE ON SCHEMA pgroonga`](grant-usage-on-schema-pgroonga.html)

## `pgroonga`インデックス

  * [`CREATE INDEX USING pgroonga`の詳細な説明](create-index-using-pgroonga.html)

  * [PGroonga対GiSTとGIN](pgroonga-versus-gist-and-gin.html)

  * [PGroonga対textsearch対pg\_trgm](pgroonga-versus-textsearch-and-pg-trgm.html)

  * [PGroonga対pg\_bigm](pgroonga-versus-pg-bigm.html)

  * [レプリケーション](replication.html)

  * [クラッシュセーフ][crash-safe]

  * [`jsonb`サポート][jsonb]

## 演算子

### 行レベルセキュリティーサポート

2.3.3で追加。

すべてのv2演算子はPostgreSQLの[行レベルセキュリティー][postgresql-row-level-security]をサポートしています。

### `text`用

#### `pgroonga_text_full_text_search_ops_v2`演算子クラス（デフォルト） {#text-full-text-search-ops-v2}

  * [`LIKE`演算子][like]

  * `ILIKE`演算子

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&@*`演算子][similar-search-v2]：類似文書検索

  * [`&~?`演算子][similar-search-v2]：類似文書検索

    * 1.2.2から非推奨です。代わりに[`&@*`演算子][similar-search-v2]を使ってください。

  * [`` &` ``演算子][script-v2]：ECMAScriptのようなクエリー言語を使った高度な検索 

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

  * [`&@>`演算子][match-in-v2]：キーワードの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@|`演算子][match-in-v2]を使ってください。

  * [`&@~|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

  * [`&?|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.2から非推奨です。代わりに[`&@~|`演算子][query-in-v2]を使ってください。

  * [`&?>`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@~|`演算子][query-in-v2]を使ってください。

#### `pgroonga_text_term_search_ops_v2`演算子クラス {#text-term-search-ops-v2}

  * `<`

    * 1.2.2で追加。

  * `<=`

    * 1.2.2で追加。

  * `=`

    * 1.2.2で追加。

  * `>=`

    * 1.2.2で追加。

  * `>`

    * 1.2.2で追加。

  * [`&=` 演算子][exact-match-search]: 完全一致検索

    * 2.4.6で追加。

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^>`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

    * 1.2.1から非推奨です。代わりに[`&^|`演算子][prefix-search-in-v2]を使ってください。

  * [`!&^|`演算子][not-prefix-search-in-v2]：プレフィックスの配列での否定前方一致検索

    * 2.2.1で追加。

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

  * [`&^~>`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

    * 1.2.1から非推奨です。代わりに[`&^~|`演算子][prefix-rk-search-in-v2]を使ってください。

#### `pgroonga_text_regexp_ops_v2`演算子クラス {#text-regexp-ops-v2}

  * [`LIKE`演算子][like]

  * `ILIKE`演算子

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`@~`演算子][regular-expression]：正規表現を使った検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&~|`演算子][regular-expression-in-v2]：正規表現の配列を使った検索

    * 2.2.1で追加。

### `text[]`用

#### `pgroonga_text_array_full_text_search_ops_v2`演算子クラス（デフォルト） {#text-array-full-text-search-ops-v2}

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&@*`演算子][similar-search-v2]：類似文書検索

  * [`&~?`演算子][similar-search-v2]：類似文書検索

    * 1.2.2から非推奨です。代わりに[`&@*`演算子][similar-search-v2]を使ってください。

  * [`` &` ``演算子][script-v2]：ECMAScriptのようなクエリー言語を使った高度な検索 

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

  * [`&@>`演算子][match-in-v2]：キーワードの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@|`演算子][match-in-v2]を使ってください。

  * [`&@~|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

  * [`&?|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.2から非推奨です。代わりに[`&@~|`演算子][query-in-v2]を使ってください。

  * [`&?>`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@~|`演算子][query-in-v2]を使ってください。

#### `pgroonga_text_array_term_search_ops_v2`演算子クラス {#text-array-term-search-ops-v2}

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^>`演算子][prefix-search-v2]：前方一致検索

    * 1.2.1から非推奨です。代わりに[`&^`演算子][prefix-search-v2]を使ってください。

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^~>`演算子][prefix-rk-search-v2]：前方一致RK検索

    * 1.2.1から非推奨です。代わりに[`&^~`演算子][prefix-rk-search-v2]を使ってください。

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

  * [`@>`演算子][contain-array]：配列を使った包含検索


    * 2.2.1で追加。

  * [`&=~`演算子][equal-query-v2]：便利なクエリー言語を使った等価検索

    * 3.0.0で追加。

### `varchar`用

#### `pgroonga_varchar_term_search_ops_v2`演算子クラス（デフォルト） {#varchar-term-search-ops-v2}

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

  * [`&=` 演算子][exact-match-search]: 完全一致検索

    * 2.4.6で追加。

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

#### `pgroonga_varchar_full_text_search_ops_v2`演算子クラス {#varchar-full-text-search-ops-v2}

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&@*`演算子][similar-search-v2]：類似文書検索

  * [`&~?`演算子][similar-search-v2]：類似文書検索

    * 1.2.2から非推奨です。代わりに[`&@*`演算子][similar-search-v2]を使ってください。

  * [`` &` ``演算子][script-v2]：ECMAScriptのようなクエリー言語を使った高度な検索 

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

  * [`&@>`演算子][match-in-v2]：キーワードの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@|`演算子][query-in-v2]を使ってください。

  * [`&@~|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

  * [`&?|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.2から非推奨です。代わりに[`&@~|`演算子][query-in-v2]を使ってください。

  * [`&?>`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

    * 1.2.1から非推奨です。代わりに[`&@~|`演算子][query-in-v2]を使ってください。

#### `pgroonga_varchar_regexp_ops_v2`演算子クラス {#varchar-regexp-ops-v2}

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`@~`演算子][regular-expression]：正規表現を使った検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`&~|`演算子][regular-expression-in-v2]：正規表現の配列を使った検索

    * 2.2.1で追加。

### `varchar[]`用

#### `pgroonga_varchar_array_term_search_ops_v2`演算子クラス（デフォルト） {#varchar-array-term-search-ops-v2}

  * [`&>`演算子][contain-term-v2]：検索対象の単語の配列に指定した単語が含まれているかをチェック

  * [`%%`演算子][contain-term]：検索対象の単語の配列に指定した単語が含まれているかをチェック

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`@>`演算子][contain-array]：配列を使った包含検索


    * 2.2.1で追加。

  * [`&=~`演算子][equal-query-v2]：便利なクエリー言語を使った等価検索

    * 3.0.0で追加。

### 真偽値、数値、タイムスタンプ用

サポートしている型：`boolean`、`smallint`、`integer`、`bigint`、`real`、`double precision`、`timestamp`、`timestamp with time zone`

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

### `jsonb`用

#### `pgroonga_jsonb_ops_v2`演算子クラス（デフォルト） {#jsonb-ops-v2}

  * [`&@`演算子][match-jsonb-v2]：`jsonb`内のすべてのテキストデータをキーワード1つで全文検索

  * [`&@~`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-jsonb-v2]を使ってください。

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

  * [`@@`演算子][script-jsonb]：ECMAScriptのようなクエリー言語を使った高度な検索

    * 新しく書くコードではこの演算子を使わないでください。後方互換製のために残っているだけの演算子です。

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

#### `pgroonga_jsonb_full_text_search_ops_v2`演算子クラス {#jsonb-full-text-search-ops-v2}

  * [`&@`演算子][match-jsonb-v2]：`jsonb`内のすべてのテキストデータをキーワード1つで全文検索

  * [`&@~`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

## 古い演算子

### `text`用

#### `pgroonga_text_full_text_search_ops`演算子クラス {#text-full-text-search-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_text_full_text_search_ops_v2`演算子クラス](#text-full-text-search-ops-v2)を使ってください。

  * [`LIKE`演算子][like]

  * `ILIKE`演算子

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 1.2.0から非推奨です。代わりに[`&@`演算子][match-v2]を使ってください。

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 1.2.0から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

#### `pgroonga_text_regexp_ops`演算子クラス {#text-regexp-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_text_regexp_ops_v2`演算子クラス](#text-regexp-ops-v2)を使ってください。

  * [`LIKE`演算子][like]

  * `ILIKE`演算子

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`@~`演算子][regular-expression]：正規表現を使った検索

    * 1.2.1から非推奨です。代わりに[`&~`演算子][regular-expression-v2]を使ってください。

### `text[]`用

#### `pgroonga_text_array_full_text_search_ops`演算子クラス {#text-array-full-text-search-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_text_array_full_text_search_ops_v2`演算子クラス](#text-array-full-text-search-ops-v2)を使ってください。

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 1.2.0から非推奨です。代わりに[`&@`演算子][match-v2]を使ってください。

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 1.2.0から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

### `varchar`用

#### `pgroonga_varchar_ops`演算子クラス {#varchar-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_varchar_term_search_ops_v2`演算子クラス](#text-varchar-term-search-ops-v2)を使ってください。

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

#### `pgroonga_varchar_full_text_search_ops`演算子クラス {#varchar-full-text-search-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_varchar_full_text_search_ops_v2`演算子クラス](#text-varchar-full-text-search-ops-v2)を使ってください。

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`%%` operator][match]：キーワード1つでの全文検索

    * 1.2.0から非推奨です。代わりに[`&@`演算子][match-v2]を使ってください。

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

  * [`@@`演算子][query]：便利なクエリー言語を使った全文検索

    * 1.2.0から非推奨です。代わりに[`&@~`演算子][query-v2]を使ってください。

#### `pgroonga_varchar_regexp_ops`演算子クラス {#varchar-regexp-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_varchar_regexp_ops_v2`演算子クラス](#text-varchar-regexp-ops-v2)を使ってください。

  * [`&~`演算子][regular-expression-v2]：正規表現を使った検索

  * [`@~`演算子][regular-expression]：正規表現を使った検索

    * 1.2.1から非推奨です。代わりに[`&~`演算子][regular-expression-v2]を使ってください。

### `varchar[]`用

#### `pgroonga_varchar_array_ops`演算子クラス {#varchar-array-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_varchar_array_term_search_ops_v2`演算子クラス](#text-varchar-array-term-search-ops-v2)を使ってください。

  * [`&>`演算子][contain-term-v2]：検索対象の単語の配列に指定した単語が含まれているかをチェック

  * [`%%`演算子][contain-term]：検索対象の単語の配列に指定した単語が含まれているかをチェック

    * 1.2.1から非推奨です。代わりに[`&>`演算子][contain-term-v2]を使ってください。

### `jsonb`用

#### `pgroonga_jsonb_ops`演算子クラス {#jsonb-ops}

2.0.0から非推奨です。

代わりに[`pgroonga_jsonb_ops_v2`演算子クラス](#text-jsonb-ops-v2)を使ってください。

  * [`&@`演算子][match-jsonb-v2]：`jsonb`内のすべてのテキストデータをキーワード1つで全文検索

  * [`&@~`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

  * [`&?`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

    * 1.2.2から非推奨です。代わりに[`&@~`演算子][query-jsonb-v2]を使ってください。

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

  * [`@@`演算子][script-jsonb]：ECMAScriptのようなクエリー言語を使った高度な検索

    * 1.2.1から非推奨です。代わりに[`` &` ``演算子][script-jsonb-v2]を使ってください。

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

## 関数

  * [`pgroonga_command`関数][command]

  * [`pgroonga_command_escape_value`関数][command-escape-value]

  * [`pgroonga_condition` function][condition]

  * [`pgroonga_escape`関数][escape]

  * [`pgroonga_flush`関数][flush]

  * [`pgroonga_database_remove`関数][database-remove]

  * [`pgroonga_highlight_html`関数][highlight-html]

  * [`pgroonga_index_column_name` 関数][index-column-name]

  * [`pgroonga_is_writable`関数][is-writable]

  * [`pgroonga_match_positions_byte`関数][match-positions-byte]

  * [`pgroonga_match_positions_character`関数][match-positions-character]

  * [`pgroonga_normalize`関数][normalize]

  * [`pgroonga_query_escape`関数][query-escape]

  * [`pgroonga_query_expand`関数][query-expand]

  * [`pgroonga_query_extract_keywords`関数][query-extract-keywords]

  * [`pgroonga_result_to_jsonb_objects`関数][result-to-jsonb-objects]

  * [`pgroonga_result_to_recordset`関数][result-to-recordset]

  * [`pgroonga_set_writable`関数][set-writable]

  * [`pgroonga_score`関数][score]

  * [`pgroonga_snippet_html`関数][snippet-html]

  * [`pgroonga_table_name`関数][table-name]

  * [`pgroonga_tokenize`関数][tokenize]

  * [`pgroonga_vacuum`関数][vacuum]

  * [`pgroonga_wal_apply`関数][wal-apply]

  * [`pgroonga_wal_set_applied_position`関数][wal-set-applied-position]

  * [`pgroonga_wal_status`関数][wal-status]

  * [`pgroonga_wal_truncate`関数][wal-truncate]

## パラメーター

  * [`pgroonga.enable_trace_log`パラメーター][enable-trace-log]

    * 3.0.8で追加。

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

  * [`pgroonga.force_match_escalation`パラメーター][force-match-escalation]

  * [`pgroonga.libgroonga_version`パラメーター][libgroonga-version]

  * [`pgroonga.lock_timeout`パラメーター][lock-timeout]

  * [`pgroonga.log_level`パラメーター][log-level]

  * [`pgroonga.log_path`パラメーター][log-path]

  * [`pgroonga.log_type`パラメーター][log-type]

  * [`pgroonga.match_escalation_threshold`パラメーター][match-escalation-threshold]

  * [`pgroonga.max_wal_size`パラメーター][max-wal-size]

    * 2.3.3で追加。

  * [`pgroonga.query_log_path`パラメーター][query-log-path]

  * [`pgroonga_crash_safer.flush_naptime`パラメーター][pgroonga-crash-safer-flush-naptime]

    * 2.3.3で追加。

  * [`pgroonga_crash_safer.log_level`パラメーター][pgroonga-crash-safer-log-level]

    * 2.3.3で追加。

  * [`pgroonga_crash_safer.log_path`パラメーター][pgroonga-crash-safer-log-path]

    * 2.3.3で追加。

  * [`pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db`パラメーター][pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db]

    * 3.1.2で追加。

  * [`pgroonga_standby_maintainer.naptime` パラメーター][pgroonga-standby-maintainer-naptime]

    * 2.4.2で追加。

## モジュール


  * [`pgroonga_check`モジュール][pgroonga-check]

    * 2.3.3から非推奨です。代わりに[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]を使ってください。

  * [`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]

    * 2.3.3で追加。

  * [`pgroonga_database`モジュール][pgroonga-database]

    * 2.3.3から非推奨です。代わりに[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]を使ってください。

  * [`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]

    * 2.3.3で追加。

    * [`pgroonga_wal_applier`モジュール][pgroonga-wal-applier] は、2.4.2から非推奨です。代わりに [`pgroonga_standby_maintainer` モジュール][pgroonga-standby-maintainer] を使ってください。

  * [`pgroonga_standby_maintainer`モジュール][pgroonga-standby-maintainer]

    * 2.4.2で追加。

## Groongaの関数

[`pgroonga_command`関数](functions/pgroonga-command.html)内で以下のGroongaの関数を使えます。`WHERE`節では使えません。

  * [`pgroonga_tuple_is_alive` Groonga関数][tuple-is-alive]

## チューニング

通常、PGroongaはデフォルトで高速に動くため、特別にPGroongaをチューニングする必要はありません。

しかし、非常に大きなデータベースを扱うなどいくつかのケースではPGroongaをチューニングする必要があります。PGroongaはバックエンドとしてGroongaを使っています。つまり、Groonga用のチューニング知識をPGroongaでも使えるということです。PGroongaをチューニングする場合は以下のGroongaのドキュメントを参照してください。

  * [チューニング][groonga-tuning]

[crash-safe]:crash-safe.html

[jsonb]:jsonb.html

[postgresql-row-level-security]:{{ site.postgresql_doc_base_url.ja }}/ddl-rowsecurity.html

[like]:operators/like.html

[match]:operators/match.html
[query]:operators/query.html
[regular-expression]:operators/regular-expression.html

[contain-array]:operators/contain-array.html
[contain-jsonb]:operators/contain-jsonb.html
[contain-term-v2]:operators/contain-term-v2.html
[contain-term]:operators/contain-term.html
[equal-query-v2]:operators/equal-query-v2.html
[exact-match-search]:operators/exact-match-search.html
[match-in-v2]:operators/match-in-v2.html
[match-jsonb-v2]:operators/match-jsonb-v2.html
[match-v2]:operators/match-v2.html
[not-prefix-search-in-v2]:operators/not-prefix-search-in-v2.html
[prefix-rk-search-in-v2]:operators/prefix-rk-search-in-v2.html
[prefix-rk-search-v2]:operators/prefix-rk-search-v2.html
[prefix-search-in-v2]:operators/prefix-search-in-v2.html
[prefix-search-v2]:operators/prefix-search-v2.html
[query-in-v2]:operators/query-in-v2.html
[query-jsonb-v2]:operators/query-jsonb-v2.html
[query-v2]:operators/query-v2.html
[regular-expression-in-v2]:operators/regular-expression-in-v2.html
[regular-expression-v2]:operators/regular-expression-v2.html
[script-jsonb-v2]:operators/script-jsonb-v2.html
[script-jsonb]:operators/script-jsonb.html
[script-v2]:operators/script-v2.html
[similar-search-v2]:operators/similar-search-v2.html

[upgrade-incompatible]:../upgrade/#incompatible-case

[command]:functions/pgroonga-command.html
[condition]:functions/pgroonga-condition.html
[command-escape-value]:functions/pgroonga-command-escape-value.html
[escape]:functions/pgroonga-escape.html
[flush]:functions/pgroonga-flush.html
[database-remove]:functions/pgroonga-database-remove.html
[highlight-html]:functions/pgroonga-highlight-html.html
[index-column-name]:functions/pgroonga-index-column-name.html
[is-writable]:functions/pgroonga-is-writable.html
[match-positions-byte]:functions/pgroonga-match-positions-byte.html
[match-positions-character]:functions/pgroonga-match-positions-character.html
[normalize]:functions/pgroonga-normalize.html
[query-escape]:functions/pgroonga-query-escape.html
[query-expand]:functions/pgroonga-query-expand.html
[query-extract-keywords]:functions/pgroonga-query-extract-keywords.html
[result-to-jsonb-objects]:functions/pgroonga-result-to-jsonb-objects.html
[result-to-recordset]:functions/pgroonga-result-to-recordset.html
[set-writable]:functions/pgroonga-set-writable.html
[score]:functions/pgroonga-score.html
[snippet-html]:functions/pgroonga-snippet-html.html
[table-name]:functions/pgroonga-table-name.html
[tokenize]:functions/pgroonga-tokenize.html
[vacuum]:functions/pgroonga-vacuum.html
[wal-apply]:functions/pgroonga-wal-apply.html
[wal-set-applied-position]:functions/pgroonga-wal-set-applied-position.html
[wal-status]:functions/pgroonga-wal-status.html
[wal-truncate]:functions/pgroonga-wal-truncate.html

[tuple-is-alive]:groonga-functions/pgroonga-tuple-is-alive.html

[enable-trace-log]:parameters/enable-trace-log.html
[enable-wal]:parameters/enable-wal.html
[force-match-escalation]:parameters/force-match-escalation.html
[libgroonga-version]:parameters/libgroonga-version.html
[lock-timeout]:parameters/lock-timeout.html
[log-level]:parameters/log-level.html
[log-path]:parameters/log-path.html
[log-type]:parameters/log-type.html
[match-escalation-threshold]:parameters/match-escalation-threshold.html
[max-wal-size]:parameters/max-wal-size.html
[query-log-path]:parameters/query-log-path.html

[pgroonga-crash-safer-flush-naptime]:parameters/pgroonga-crash-safer-flush-naptime.html
[pgroonga-crash-safer-log-level]:parameters/pgroonga-crash-safer-log-level.html
[pgroonga-crash-safer-log-path]:parameters/pgroonga-crash-safer-log-path.html

[pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db]:parameters/pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db.html
[pgroonga-standby-maintainer-naptime]:parameters/pgroonga-standby-maintainer-naptime.html

[pgroonga-check]:modules/pgroonga-check.html
[pgroonga-crash-safer]:modules/pgroonga-crash-safer.html
[pgroonga-database]:modules/pgroonga-database.html
[pgroonga-wal-applier]:modules/pgroonga-wal-applier.html
[pgroonga-standby-maintainer]:modules/pgroonga-standby-maintainer.html

[groonga-tuning]:https://groonga.org/ja/docs/reference/tuning.html
