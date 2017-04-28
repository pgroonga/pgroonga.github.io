---
title: Ubuntuにインストール
---

# Ubuntuにインストール

このドキュメントはUbuntuにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているUbuntuのバージョンは次の通りです。

  * Ubuntu 14.04

  * Ubuntu 16.04

  * Ubuntu 16.10

  * Ubuntu 17.04

## インストール方法

UbuntuでPGroongaをインストールする手順は次の通りです。

Ubuntu 14.04を使っている場合は`postgresql-9.3-pgroonga`パッケージをインストールしてください。

Ubuntu 17.04を使っている場合は`postgresql-9.6-pgroonga`パッケージをインストールしてください。

それ以外の場合は`postgresql-9.5-pgroonga`パッケージをインストールしてください。

```text
% sudo apt-get install -y software-properties-common
% sudo add-apt-repository -y universe
% sudo add-apt-repository -y ppa:groonga/ppa
% sudo apt-get update
Ubuntu 14.04:
% sudo apt-get install -y -V postgresql-9.3-pgroonga
Ubuntu 17.04:
% sudo apt-get install -y -V postgresql-9.6-pgroonga
Others:
% sudo apt-get install -y -V postgresql-9.5-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo apt-get install -y -V groonga-tokenizer-mecab
```

データベースを作成します。

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
