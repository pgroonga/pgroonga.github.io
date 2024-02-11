---
title: Windowsにインストール
---

# Windowsにインストール

このドキュメントはWindowsにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

32bitバージョンのWindowsでも64bitバージョンのWindowsでも構いません。PostgreSQLがサポートしているすべてのWindowsで使えます。

## インストール方法

PostgreSQL（対応バージョン：{{ site.windows_postgresql_versions | join: "、" }}）をインストールします。[インストーラーバージョン][windows-postgresql-download-installer]か[zipバージョン][windows-postgresql-download-zip]を選んでください。

PGroongaのパッケージをダウンロードします。

{% for windows_postgresql_version in site.windows_postgresql_versions %}

{% assign windows_postgresql_major_version = windows_postgresql_version | split: "." | first %}
{% if windows_postgresql_major_version == "9" or
      windows_postgresql_major_version == "10" %}

  * [32bitバージョンのPostgreSQL {{ windows_postgresql_version }}用](https://github.com/pgroonga/pgroonga/releases/download/{{ site.pgroonga_version }}/pgroonga-{{ site.pgroonga_version }}-postgresql-{{ windows_postgresql_version }}-x86.zip)

{% endif %}

  * [64bitバージョンのPostgreSQL {{ windows_postgresql_version }}用](https://github.com/pgroonga/pgroonga/releases/download/{{ site.pgroonga_version }}/pgroonga-{{ site.pgroonga_version }}-postgresql-{{ windows_postgresql_version }}-x64.zip)

{% endfor %}

ダウンロードしたPGroongaを展開します。展開先のフォルダーにはPostgreSQLのフォルダーを指定してください。

インストーラーバージョンのPostgreSQLを使っている場合は`C:\Program Files\PostgreSQL\%POSTGRESQL_VERSION%`が展開先のフォルダーです。

zipバージョンのPostgreSQLをインストールした場合は`%PostgreSQLのzipを展開したフォルダー%\pgsql`が展開先のフォルダーになります。

データベースを作成します。

```text
postgres=# CREATE DATABASE pgroonga_test;
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを利用するべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
postgres=# \c pgroonga_test
pgroonga_test=# CREATE EXTENSION pgroonga;
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。

[windows-postgresql-download-installer]: https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
[windows-postgresql-download-zip]: https://www.enterprisedb.com/download-postgresql-binaries
