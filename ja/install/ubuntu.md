---
title: Ubuntuにインストール
---

# Ubuntuにインストール

このドキュメントはUbuntuにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているUbuntuのバージョンは次の通りです。

  * Ubuntu 16.04

  * Ubuntu 18.04

  * Ubuntu 19.10

  * Ubuntu 20.04

## インストール方法

UbuntuでPGroongaをインストールする手順は次の通りです。

Ubuntu 16.04を使っている場合は`postgresql-9.5-pgroonga`パッケージをインストールしてください。

Ubuntu 18.04を使っている場合は`postgresql-10-pgroonga`パッケージをインストールしてください。

Ubuntu 19.10を使っている場合は`postgresql-11-pgroonga`パッケージをインストールしてください。

それ以外の場合は`postgresql-12-pgroonga`パッケージをインストールしてください。

```console
$ sudo apt install -y software-properties-common
$ sudo add-apt-repository -y universe
$ sudo add-apt-repository -y ppa:groonga/ppa
$ sudo apt update
Ubuntu 16.04:
$ sudo apt install -y -V postgresql-9.5-pgroonga
Ubuntu 18.04:
$ sudo apt install -y -V postgresql-10-pgroonga
Ubuntu 19.10:
$ sudo apt install -y -V postgresql-11-pgroonga
Others:
$ sudo apt install -y -V postgresql-12-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo apt install -y -V groonga-tokenizer-mecab
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
