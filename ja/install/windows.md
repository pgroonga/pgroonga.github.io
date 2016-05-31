---
title: Windowsにインストール
---

# Windowsにインストール

このドキュメントはWindowsにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

32bitバージョンのWindowsでも64bitバージョンのWindowsでも構いません。PostgreSQLがサポートしているすべてのWindowsで使えます。

## インストール方法

PostgreSQL {{ site.windows_postgresql_version }}をインストールします。[インストーラーバージョン](http://www.enterprisedb.com/products-services-training/pgdownload)か[zipバージョン](http://www.enterprisedb.com/products-services-training/pgbindownload)を選んでください。

PGroongaのパッケージをダウンロードします。

  * [32bitバージョン](https://github.com/pgroonga/pgroonga/releases/download/{{ site.pgroonga_version }}/pgroonga-{{ site.pgroonga_version }}-postgresql-{{ site.windows_postgresql_version }}-x86.zip)
  * [64bitバージョン](https://github.com/pgroonga/pgroonga/releases/download/{{ site.pgroonga_version }}/pgroonga-{{ site.pgroonga_version }}-postgresql-{{ site.windows_postgresql_version }}-x64.zip)

ダウンロードしたPGroongaを展開します。展開先のフォルダーにはPostgreSQLのフォルダーを指定してください。

インストーラーバージョンのPostgreSQLを使っている場合は`C:\Program Files\PostgreSQL\{{ site.windows_postgresql_short_version }}`が展開先のフォルダーです。

zipバージョンのPostgreSQLをインストールした場合は`%PostgreSQLのzipを展開したフォルダー%\pgsql`が展開先のフォルダーになります。

データベースを作成します。

```text
postgres=# CREATE DATABASE pgroonga_test;
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
postgres=# \c pgroonga_test
pgroonga_test=# CREATE EXTENSION pgroonga;
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
