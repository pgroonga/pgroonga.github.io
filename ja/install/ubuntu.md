---
title: Ubuntuにインストール
layout: ja
---

# Ubuntuにインストール

このドキュメントはUbuntuにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているUbuntuのバージョンは次の通りです。

  * Ubuntu 14.10
  * Ubuntu 15.04
  * Ubuntu 15.10

## インストール方法

PGroongaをインストールする方法は次の通りです。サポートしているすべてのバージョンのUbuntuで共通です。

`postgresql-9.4-pgroonga`パッケージをインストールします。

```text
% sudo apt-get install -y software-properties-common
% sudo add-apt-repository -y universe
% sudo add-apt-repository -y ppa:groonga/ppa
% sudo apt-get update
% sudo apt-get install -y -V postgresql-9.4-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo apt-get install -y -V groonga-tokenizer-mecab
```

データベースを作成します。

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
