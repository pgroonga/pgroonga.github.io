---
title: Debian GNU/Linuxにインストール
---

# Debian GNU/Linuxにインストール

このドキュメントはDebian GNU/LinuxにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているDebian GNU/Linuxのバージョンは次の通りです。

  * [Stretch](#install-on-stretch)

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
deb [signed-by=/usr/share/keyrings/groonga-archive-keyring.gpg] https://packages.groonga.org/debian/ stretch main
deb-src [signed-by=/usr/share/keyrings/groonga-archive-keyring.gpg] https://packages.groonga.org/debian/ stretch main
```

PostgreSQL 10を使いたい場合は[PostgreSQLが提供しているAPTリポジトリー][postgresql-apt]を追加します。

```console
% echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
% wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

`postgresql-9.6-pgroonga`または`postgresql-10-pgroonga`パッケージをインストールします。

```console
% sudo wget -O /usr/share/keyrings/groonga-archive-keyring.gpg https://packages.groonga.org/debian/groonga-archive-keyring.gpg
% sudo apt update
% sudo apt install -y -V postgresql-9.6-pgroonga
Or
% sudo apt install -y -V postgresql-10-pgroonga
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

postgresql-apt:https://www.postgresql.org/download/linux/debian/
