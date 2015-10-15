---
title: OS Xにインストール
layout: ja
---

# OS Xにインストール

このドキュメントはPGroongaをOS Xにインストールする方法を説明します。

{: #homebrew}

## Homebrewを使ったインストール方法

Homebrewを使ってPGroongaをインストールできます。

```text
% brew install postgresql --with-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga`パッケージを`--with-mecab`オプション付きでインストールし直す必要があります。

```text
% brew reinstall groonga --with-mecab
```

データベースを作成します。

```text
% psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
