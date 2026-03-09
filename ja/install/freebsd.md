---
title: FreeBSDにインストール
---

# FreeBSDにインストール

このドキュメントはFreeBSDにPGroongaをインストールする方法を説明します。

## インストール方法

FreeBSDにPGroongaをインストールする方法は次の通りです。

`pkg`でPGroongaとPostgreSQLをインストールします。

```console
$ sudo pkg install -y pgroonga postgresql{{ site.freebsd_postgresql_version }}-server
```

トークナイザーとして[MeCab](http://taku910.github.io/mecab/)を利用する場合は、`japanese/mecab-ipadic`を追加でインストールします。

```console
$ sudo pkg install -y japanese/mecab-ipadic
```

PostgreSQLを有効にするために次の内容の`/etc/rc.conf.d/postgresql`を作ります。

`/etc/rc.conf.d/postgresql`:

```text
postgresql_enable="YES"
```

PostgreSQLのデータベースを初期化します。

```console
$ sudo -H /usr/local/etc/rc.d/postgresql initdb
```

PostgreSQLを起動します。

```console
$ sudo -H service postgresql start
```

データベースを作成します。

```console
$ sudo -H -u postgres psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを利用するべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
$ sudo -H -u postgres psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga;'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
