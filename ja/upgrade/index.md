---
title: アップグレード
---

# アップグレード

新しいバージョンのPGroongaが非互換の変更を含んでいない場合はPGroongaのインデックスを再作成せずにアップグレードできます。新しいバージョンが1つでも非互換の変更を含んでいればPGroongaをアップグレードする際にすべてのPGroongaのインデックスを再作成する必要があります。

以下は互換性のリストです。

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

## 参考

  * [`CREATE EXTENSION`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/sql-createextension.html)

  * [`DROP EXTENSION`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/sql-dropextension.html)

  * [`ALTER EXTENSION`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/sql-alterextension.html)

  * [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)
