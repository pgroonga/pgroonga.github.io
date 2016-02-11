---
title: OS Xにインストール
layout: ja
---

# OS Xにインストール

このドキュメントはPGroongaをOS Xにインストールする方法を説明します。

## Homebrewを使ったインストール方法 {#homebrew}

Homebrewを使ってPGroongaをインストールできます。

```text
% brew install pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga`パッケージを`--with-mecab`オプション付きでインストールし直す必要があります。

```text
% brew reinstall groonga --with-mecab
```

データベースを作成します。

```text
% psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
