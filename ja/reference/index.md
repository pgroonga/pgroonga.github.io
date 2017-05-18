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

  * [`jsonb`サポート](jsonb.html)

## 演算子

### For `text`

By the default operator class:

  * [`LIKE`演算子](operators/like.html)

  * `ILIKE`演算子

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * 1.2.0から非推奨になりました。代わりに[`&@`演算子](operators/match-v2.html)を使ってください。

  * [`&?` operator](operators/query-v2.html): Full text search by easy to use query language

  * [`@@` operator](operators/query.html): Full text search by easy to use query language

    * 1.2.0から非推奨になりました。代わりに[`&?`演算子](operators/query-v2.html)を使ってください。

`pgroonga.text_regexp_ops`演算子クラスが提供：

  * [`LIKE`演算子](operators/like.html)

  * `ILIKE`演算子

  * [`&~` operator](operators/regular-expression-v2.html): Search by a regular expression

  * [`@~`演算子](operators/regular-expression.html)：正規表現で検索

    * 1.2.1から非推奨になりました。代わりに[`&~`演算子](operators/regular-expression-v2.html)を使ってください。

### For `text[]`

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * 1.2.0から非推奨になりました。代わりに[`&@`演算子](operators/match-v2.html)を使ってください。

  * [`&?` operator](operators/query-v2.html): Full text search by easy to use language

  * [`@@` operator](operators/query.html): Full text search by easy to use language

    * 1.2.0から非推奨になりました。代わりに[`&?`演算子](operators/query-v2.html)を使ってください。

### For `varchar`

By the default operator class:

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

`pgroonga.varchar_full_text_search_ops`演算子クラスが提供：

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * 1.2.0から非推奨になりました。代わりに[`&@`演算子](operators/match-v2.html)を使ってください。

  * [`&?` operator](operators/query-v2.html): Full text search by easy to use language

  * [`@@` operator](operators/query.html): Full text search by easy to use language

    * 1.2.0から非推奨になりました。代わりに[`&?`演算子](operators/query-v2.html)を使ってください。

By `pgroonga.varchar_regexp_ops` operator class:

  * [`&~` operator](operators/regular-expression-v2.html): Search by regular expression

  * [`@~`演算子](operators/regular-expression.html)：正規表現で検索

    * 1.2.1から非推奨になりました。代わりに[`&~`演算子](operators/regular-expression-v2.html)を使ってください。

### For `varchar[]`

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * 1.2.1から非推奨になりました。代わりに[`&@`演算子](operators/match-v2.html)を使ってください。

### For boolean, numbers and timestamps

Supported types: `boolean`, `smallint`, `integer`, `bigint`, `real`, `double precision`, `timestamp` and `timestamp with time zone`

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

### For `jsonb`

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`&?` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@@` operator][script-jsonb]: Advanced search by ECMAScript like query language

    * Deprecated since 1.2.1. Use [`` &` `` operator][script-jsonb-v2] instead.

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

## v2演算子

PGroonga 1.Y.Zは`pgroonga.XXX_v2`という演算子クラスを提供します。これらはPGroonga 2.0.0になるまで後方互換性を提供しません。しかし、これらの演算子クラスには新しいバージョンがリリースされるごとに積極的に多くの改良が入ります。

これらを使った場合、PGroongaをアップグレードする場合は[非互換の場合の手順](../upgrade/#incompatible-case)を使う必要があります。

### For `text`

`pgroonga.text_full_text_search_ops_v2`演算子クラスが提供：

  * [`LIKE`演算子](operators/like.html)

  * `ILIKE`演算子

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&?` operator](operators/query-v2.html): Full text search by easy to use query language

  * [`@@` operator](operators/query.html): Full text search by easy to use query language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

    * [`&~?`演算子](operators/similar-search-v2.html)：類似文書検索

  * [`` &` `` operator](operators/script-v2.html): Advanced search by ECMAScript like query language 

  * [`&@>` operator](operators/match-contain-v2.html): Full text search by an array of keywords

  * [`&?>` operator](operators/query-contain-v2.html): Full text search by an array of queries in easy to use query language

`pgroonga.text_term_search_ops_v2`演算子クラスが提供：

    * [`&^`演算子](operators/prefix-search-v2.html)：前方一致検索

    * [`&^~`演算子](operators/prefix-rk-search-v2.html)：前方一致RK検索

  * [`&^>` operator](operators/prefix-search-contain-v2.html): Prefix search by an array of prefixes

  * [`&^~>` operator](operators/prefix-rk-search-contain-v2.html): Prefix RK search by an array of prefixes

`pgroonga.text_regexp_ops_v2`演算子クラスが提供：

  * [`LIKE`演算子](operators/like.html)

  * `ILIKE`演算子

  * [`&~` operator](operators/regular-expression-v2.html): Search by regular expression

  * [`@~`演算子](operators/regular-expression.html)：正規表現で検索

    * Don't use this operator class for newly written code. It's just for backward compatibility.

### For `text[]`

`pgroonga.text_full_text_search_ops_v2`演算子クラスが提供：

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&?` operator](operators/query-v2.html): Full text search by easy to use language

  * [`@@` operator](operators/query.html): Full text search by easy to use language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

    * [`&~?`演算子](operators/similar-search-v2.html)：類似文書検索

  * [`` &` `` operator](operators/script-v2.html): Advanced search by ECMAScript like query language 

  * [`&@>` operator](operators/match-contain-v2.html): Full text search by an array of keywords

  * [`&?>` operator](operators/query-contain-v2.html): Full text search by an array of queries in easy to use query language

`pgroonga.text_array_term_search_ops_v2`演算子クラスが提供：

    * [`&^`演算子](operators/prefix-search-v2.html)：前方一致検索

    * [`&^~`演算子](operators/prefix-rk-search-v2.html)：前方一致RK検索

  * [`&^>` operator](operators/prefix-search-contain-v2.html): Prefix search by an array of prefixes

  * [`&^~>` operator](operators/prefix-rk-search-contain-v2.html): Prefix RK search by an array of prefixes

### For `varchar`

`pgroonga.varchar_full_text_search_ops_v2`演算子クラスが提供：

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&?` operator](operators/query-v2.html): Full text search by easy to use query language

  * [`@@` operator](operators/query.html): Full text search by easy to use query language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

    * [`&~?`演算子](operators/similar-search-v2.html)：類似文書検索

  * [`` &` `` operator](operators/script-v2.html): Advanced search by ECMAScript like query language 

  * [`&@>` operator](operators/match-contain-v2.html): Full text search by an array of keywords

  * [`&?>` operator](operators/query-contain-v2.html): Full text search by an array of queries in easy to use query language

By `pgroonga.varchar_regexp_ops_v2` operator class:

  * [`&~` operator](operators/regular-expression-v2.html): Search by regular expression

  * [`@~`演算子](operators/regular-expression.html)：正規表現で検索

    * Don't use this operator class for newly written code. It's just for backward compatibility.

### For `varchar[]`

By `pgroonga.varchar_array_ops_v2` operator class:

  * [`&@`演算子](operators/match-v2.html)

  * [`%%`演算子](operators/match.html)：キーワード1つでの全文検索

    * Don't use this operator class for newly written code. It's just for backward compatibility.

### For `jsonb`

By `pgroonga.jsonb_ops_v2` operator class:

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`&?` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@@` operator][script-jsonb]: Advanced search by ECMAScript like query language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

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

## モジュール


  * [`pgroonga_check`モジュール](modules/pgroonga-check.html)

## Groongaの関数

[`pgroonga.command`関数](functions/pgroonga-command.html)内で以下のGroongaの関数を使えます。`WHERE`節では使えません。

  * [`pgroonga_tuple_is_alive` Groonga関数](groonga-functions/pgroonga-tuple-is-alive.html)

## チューニング

通常、PGroongaはデフォルトで高速に動くため、特別にPGroongaをチューニングする必要はありません。

しかし、非常に大きなデータベースを扱うなどいくつかのケースではPGroongaをチューニングする必要があります。PGroongaはバックエンドとしてGroongaを使っています。つまり、Groonga用のチューニング知識をPGroongaでも使えるということです。PGroongaをチューニングする場合は以下のGroongaのドキュメントを参照してください。

  * [チューニング](http://groonga.org/ja/docs/reference/tuning.html)

[match-jsonb-v2]:operators/match-jsonb-v2.html
[query-jsonb-v2]:operators/query-jsonb-v2.html
[script-jsonb-v2]:operators/script-jsonb-v2.html
[script-jsonb]:operators/script-jsonb.html
[contain-jsonb]:operators/contain-jsonb.html
