---
title: インストール
---

# インストール

主要なプラットフォームではパッケージがあります。パッケージを使うことで簡単にPGroongaをインストールできます。

それぞれのプラットフォームごとにドキュメントがあります。それとは別にソースからPGroongaをビルドするためのドキュメントがあります。

サポートしているPostgreSQLのバージョンは次の通りです。

  * 9.3
  * 9.4
  * 9.5
  * 9.6

もし、これより古いPostgreSQLを使っているなら、PGroongaをインストールする前にPostgreSQLをアップグレードしてください。

次の中から自分のプラットフォーム用のドキュメントを選んで参照してください。

  * [Debian GNU/Linux](debian.html)

    * Jessie

  * [Ubuntu](ubuntu.html)

    * 14.04

    * 15.04

    * 15.10

    * 16.04

  * [CentOS](centos.html)

    * 5

    * 6

    * 7

  * [OS X](os-x.html)

    * Homebrew

  * [Windows](windows.html)

{% for windows_postgresql_version in site.windows_postgresql_versions %}

    * 32bit + PostgreSQL {{ windows_postgresql_version }}

    * 64bit + PostgreSQL {{ windows_postgresql_version }}

{% endfor %}

もし、このリストの中に自分のプラットフォームがない場合は、[ソースからビルドしてインストールする](source.html)か[issue](https://github.com/pgroonga/pgroonga/issues/new)にリクエストを送ってください。

## アンインストール

次のSQLでPGroongaをアンインストールできます。

```sql
DROP EXTENSION pgroonga CASCADE;
```

PostgreSQL 9.5以前を使っている場合は以下のSQLも実行する必要があります。

```sql
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```
