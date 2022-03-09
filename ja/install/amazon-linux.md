---
title: Amazon Linux にインストール
---

# Amazon Linux にインストール

このドキュメントはPGroongaをAmazon Linuxにインストールする方法を説明します。

## サポートしているバージョン

サポートしているAmazon Linuxのバージョンは次の通りです。

  * [Amazon Linux 2](#install-on-2)

## Amazon Linux 2 にインストールする方法 {#install-on-2}

Amazon Linux 2にPGroongaをインストールする方法は次の通りです。

`postgresql{{ site.latest_amazon_linux_postgresql_version.major }}`パッケージをインストールします。

```console
$ sudo -H amazon-linux-extras install -y epel postgresql{{ site.latest_amazon_linux_postgresql_version }}
$ sudo -H yum install -y ca-certificates
$ sudo -H yum install -y https://packages.groonga.org/amazon-linux/2/groonga-release-latest.noarch.rpm
$ sudo -H yum install -y postgresql{{ site.latest_amazon_linux_postgresql_version }}-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```console
$ sudo -H postgresql-setup initdb
$ sudo -H systemctl enable --now postgresql
```

データベースを作成します。

```console
$ sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
$ sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
