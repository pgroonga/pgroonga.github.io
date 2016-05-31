---
title: Debian GNU/Linuxにインストール
---

# Debian GNU/Linuxにインストール

このドキュメントはDebian GNU/LinuxにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているDebian GNU/Linuxのバージョンは次の通りです。

  * Jessie

## Debian GNU/Linux Jessieにインストールする方法

Debian GNU/Linux JessieにPGroongaをインストールする方法は次の通りです。

GroongaのAPTリポジトリーを追加します。

`/etc/apt/sources.list.d/groonga.list`:

```text
deb http://packages.groonga.org/debian/ jessie main
deb-src http://packages.groonga.org/debian/ jessie main
```

`postgresql-9.4-pgroonga`パッケージをインストールします。

```text
% sudo apt-get update
% sudo apt-get install -y -V --allow-unauthenticated groonga-keyring
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

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
