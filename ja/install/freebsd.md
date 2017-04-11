---
title: FreeBSDにインストール
---

# FreeBSDにインストール

このドキュメントはFreeBSDにPGroongaをインストールする方法を説明します。

## インストール方法

FreeBSDにPGroongaをインストールする方法は次の通りです。

`pkg`でGroongaとPostgreSQLとpkg-configとGNU Makeをインストールします。

```text
% sudo pkg install -f groonga pkgconf postgresql{{ site.freebsd_postgresql_version }}-server
```

PostgreSQLを有効にするために次の内容の`/etc/rc.conf.d/postgresql`を作ります。

`/etc/rc.conf.d/postgresql`:

```text
postgresql_enable="YES"
```

PostgreSQLのデータベースを初期化します。

```text
% sudo -H /usr/local/etc/rc.d/postgresql initdb
```

PostgreSQLを起動します。

```text
% sudo -H service postgresql start
```

ソースからPGroongaをインストールします。

```text
% curl -O https://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.tar.gz
% tar xvf pgroonga-{{ site.pgroonga_version }}.tar.gz
% cd pgroonga-{{ site.pgroonga_version }}
% gmake HAVE_MSGPACK=1
% sudo -H gmake install
```

データベースを作成します。

```text
% sudo -H -u postgres psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% sudo -H -u postgres psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga;'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
