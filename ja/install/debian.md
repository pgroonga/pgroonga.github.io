---
title: Debian GNU/Linuxにインストール
---

# Debian GNU/Linuxにインストール

このドキュメントはDebian GNU/LinuxにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているDebian GNU/Linuxのバージョンは次の通りです。

  * [Jessie](#install-on-jessie)

  * [Stretch](#install-on-stretch)

## Debian GNU/Linux Jessieにインストールする方法 {#install-on-jessie}

Debian GNU/Linux JessieにPGroongaをインストールする方法は次の通りです。

`apt-transport-https`パッケージをインストールします。

```console
% sudo apt update
% sudo apt install -y -V apt-transport-https
```

GroongaのAPTリポジトリーを追加します。

`/etc/apt/sources.list.d/groonga.list`:

```text
deb https://packages.groonga.org/debian/ jessie main
deb-src https://packages.groonga.org/debian/ jessie main
```

`postgresql-9.4-pgroonga`パッケージをインストールします。

```console
% sudo apt update
% sudo apt install -y -V --allow-unauthenticated groonga-keyring
% sudo apt update
% sudo apt install -y -V postgresql-9.4-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
% sudo apt-get install -y -V groonga-tokenizer-mecab
```

データベースを作成します。

```console
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。

## Debian GNU/Linux Stretchにインストールする方法 {#install-on-stretch}

Debian GNU/Linux StretchにPGroongaをインストールする方法は次の通りです。

`apt-transport-https`パッケージをインストールします。

```console
% sudo apt update
% sudo apt install -y -V apt-transport-https
```

GroongaのAPTリポジトリーを追加します。

`/etc/apt/sources.list.d/groonga.list`:

```text
deb https://packages.groonga.org/debian/ stretch main
deb-src https://packages.groonga.org/debian/ stretch main
```

`postgresql-9.6-pgroonga`パッケージをインストールします。

```console
% sudo apt update
% sudo apt install -y -V --allow-unauthenticated groonga-keyring
% sudo apt update
% sudo apt install -y -V postgresql-9.6-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
% sudo apt-get install -y -V groonga-tokenizer-mecab
```

データベースを作成します。

```console
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
