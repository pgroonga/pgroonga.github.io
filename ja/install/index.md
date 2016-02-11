---
title: インストール
layout: ja
---

# インストール

主要なプラットフォームではパッケージがあります。パッケージを使うことで簡単にPGroongaをインストールできます。

それぞれのプラットフォームごとにドキュメントがあります。それとは別にソースからPGroongaをビルドするためのドキュメントがあります。

サポートしているPostgreSQLのバージョンは次の通りです。

  * 9.3
  * 9.4
  * 9.5

もし、これより古いPostgreSQLを使っているなら、PGroongaをインストールする前にPostgreSQLをアップグレードしてください。

次の中から自分のプラットフォーム用のドキュメントを選んで参照してください。

  * [Debian GNU/Linux](debian.html)
    * Jessie
  * [Ubuntu](ubuntu.html)
    * 14.04
    * 15.04
    * 15.10
  * [CentOS](centos.html)
    * 5
    * 6
    * 7
  * [OS X](os-x.html)
    * Homebrew
  * [Windows](windows.html)
    * 32bit + PostgreSQL {{ site.windows_postgresql_version }}
    * 64bit + PostgreSQL {{ site.windows_postgresql_version }}

もし、このリストの中に自分のプラットフォームがない場合は、[ソースからビルドしてインストールする](source.html)か[issue](https://github.com/pgroonga/pgroonga/issues/new)にリクエストを送ってください。

## アンインストール

次のSQLでPGroongaをアンインストールできます。

```sql
DROP EXTENSION pgroonga CASCADE;
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```

手動で`pg_catalog.pg_am`からPGroongaを削除しなければいけないのはおかしいかもしれません。もし、正しいSQLを知っていたら[教えてください](https://github.com/pgroonga/pgroonga/issues/new)。
