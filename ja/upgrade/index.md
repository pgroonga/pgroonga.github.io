---
title: アップグレード
upper_level: ../
---

# アップグレード

新しいバージョンのPGroongaが非互換の変更を含んでいない場合はPGroongaのインデックスを再作成せずにアップグレードできます。新しいバージョンが1つでも非互換の変更を含んでいればPGroongaをアップグレードする際にすべてのPGroongaのインデックスを再作成する必要があります。

以下は互換性のリストです。

  * 2.4.6 -> 2.4.7 : 互換

  * 2.4.5 -> 2.4.6: 互換

  * 2.4.4 -> 2.4.5: 互換

  * 2.4.3 -> 2.4.4: 互換

  * 2.4.2 -> 2.4.3: 互換

  * 2.4.1 -> 2.4.2: 互換

  * 2.4.0 -> 2.4.1: 互換

  * 2.3.9 -> 2.4.0: 互換

  * 2.3.8 -> 2.3.9: 互換

  * 2.3.7 -> 2.3.8: 互換

  * 2.3.6 -> 2.3.7: 互換

  * 2.3.5 -> 2.3.6: 互換

  * 2.3.4 -> 2.3.5: 互換

  * 2.3.3 -> 2.3.4: 互換

  * 2.3.2 -> 2.3.3: 互換

  * 2.3.1 -> 2.3.2: 互換

  * 2.3.0 -> 2.3.1: 互換

  * 2.2.9 -> 2.3.0: 互換

  * 2.2.8 -> 2.2.9: 互換

  * 2.2.7 -> 2.2.8: 互換

  * 2.2.6 -> 2.2.7: 互換

  * 2.2.5 -> 2.2.6: 互換

    * ただし、`jsonb`を使ったPGroongaのインデックスがある場合は再作成する必要があります。

  * 2.2.4 -> 2.2.5: 互換

  * 2.2.3 -> 2.2.4: 互換

  * 2.2.2 -> 2.2.3: 互換

  * 2.2.1 -> 2.2.2: 互換

  * 2.2.0 -> 2.2.1: 互換

  * 2.1.9 -> 2.2.0: 互換

  * 2.1.8 -> 2.1.9: 互換

  * 2.1.7 -> 2.1.8: 互換

  * 2.1.6 -> 2.1.7: 互換

  * 2.1.4 -> 2.1.6: 互換

  * 2.1.3 -> 2.1.4: 互換

  * 2.1.2 -> 2.1.3: 互換

  * 2.1.1 -> 2.1.2: 互換

  * 2.1.0 -> 2.1.1: 互換

  * 2.0.9 -> 2.1.0: 互換

  * 2.0.8 -> 2.0.9: 互換

  * 2.0.7 -> 2.0.8: 互換

  * 2.0.6 -> 2.0.7: 互換

  * 2.0.5 -> 2.0.6: 互換

    * ただし、`timestamp (without time zone)`を使ったPGroongaのインデックスがある場合は再作成する必要があります。

  * 2.0.4 -> 2.0.5: 互換

  * 2.0.3 -> 2.0.4: 互換

  * 2.0.2 -> 2.0.3: 互換

    * ただし、`timestamp (without time zone)`を使ったPGroongaのインデックスがある場合は再作成する必要があります。

    * ただし、[`pgroonga_text_array_full_text_search_ops_v2`演算子クラス][text-array-full-text-search-ops-v2]を使ったPGroongaのインデックスがある場合は再作成する必要があります。

  * 2.0.1 -> 2.0.2: 互換

  * 2.0.0 -> 2.0.1: 互換

  * 1.2.3 -> 2.0.0: 互換

  * 1.2.2 -> 1.2.3: 互換

  * 1.2.1 -> 1.2.2: 互換

  * 1.2.0 -> 1.2.1: 互換

  * 1.1.9 -> 1.2.0: 互換

  * 1.1.8 -> 1.1.9: 互換

  * 1.1.7 -> 1.1.8: 互換

  * 1.1.6 -> 1.1.7: 互換

  * 1.1.5 -> 1.1.6: 互換

  * 1.1.4 -> 1.1.5: 互換

  * 1.1.3 -> 1.1.4: 互換

  * 1.1.2 -> 1.1.3: 互換

  * 1.1.1 -> 1.1.2: 互換

  * 1.1.0 -> 1.1.1: 互換

  * 1.0.9 -> 1.1.0: 互換

  * 1.0.8 -> 1.0.9: 互換

  * 1.0.7 -> 1.0.8: 互換

  * 1.0.6 -> 1.0.7: 互換

  * 1.0.5 -> 1.0.6: 互換

  * 1.0.4 -> 1.0.5: 互換

  * 1.0.3 -> 1.0.4: 互換

  * 1.0.2 -> 1.0.3: 互換

  * 1.0.1 -> 1.0.2: 互換

  * 1.0 -> 1.0.1: 互換

  * 0.9 -> 1.0: 非互換

  * 0.8 -> 0.9: 互換

  * 0.7 -> 0.8: 非互換

## 非互換の場合 {#incompatible-case}

アップグレード手順は次の通りです。

  1. すべてのPGroongaを使ったインデックスを削除します。

  1. PGroonga拡張を削除します。

  1. PGroongaのバイナリーをアップグレードします。

  1. PGroonga拡張をインストールします。

  1. すべてのPGroongaのインデックスを作り直します。

すべてのPGroongaのインデックスを削除して、PGroonga拡張も削除するSQLは次の通りです。

```sql
DROP EXTENSION pgroonga CASCADE;
```

PGroongaのバイナリーはパッケージでアップグレードできます。あるいは、新しいPGroongaをビルドして古いPGroongaに上書きすることでもアップグレードできます。

PGroonga拡張をインストールするSQLは次の通りです。

```sql
CREATE EXTENSION pgroonga;
```

PGroongaを使ってインデックスを作るには[`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)を使ってください。

## 互換性がある場合 {#compatible-case}

アップグレード手順は次の通りです。

  1. PGroongaを使っているすべてのデータベースへの接続を切断します。

  1. PGroongaのバイナリーをアップグレードします。

  1. PGroongaを使っているデータベースに接続します。

  1. PGroonga拡張をアップグレードします。

PGroongaのバイナリーはパッケージでアップグレードできます。あるいは、新しいPGroongaをビルドして古いPGroongaに上書きすることでもアップグレードできます。

PGroongaをアップグレードするSQLは次の通りです。

```sql
ALTER EXTENSION pgroonga UPDATE;
```

もし[`pgroonga_database`モジュール][pgroonga-database]を使っているなら、次のSQLを実行して`pgroonga_database`モジュールをアップグレードする必要があります。

```sql
ALTER EXTENSION pgroonga_database UPDATE;
```

## 参考

  * [`CREATE EXTENSION`]({{ site.postgresql_doc_base_url.ja }}/sql-createextension.html)

  * [`DROP EXTENSION`]({{ site.postgresql_doc_base_url.ja }}/sql-dropextension.html)

  * [`ALTER EXTENSION`]({{ site.postgresql_doc_base_url.ja }}/sql-alterextension.html)

  * [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)

[text-array-full-text-search-ops-v2]:../reference/#text-array-full-text-search-ops-v2

[pgroonga-database]:../reference/modules/pgroonga-database.html
