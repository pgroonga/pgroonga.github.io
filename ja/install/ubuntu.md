---
title: Ubuntuにインストール
---

# Ubuntuにインストール

このドキュメントはUbuntuにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているUbuntuのバージョンは次の通りです。

  * Ubuntu 24.04

  * Ubuntu 22.04

## システムのPostgreSQL用のインストール方法 {#install-for-system-postgresql}

UbuntuでシステムのPostgreSQL用にPGroongaをインストールする手順は次の通りです。

Ubuntu 22.04を使っている場合は`postgresql-14-pgroonga`パッケージをインストールしてください。

Ubuntu 24.04を使っている場合は`postgresql-16-pgroonga`パッケージをインストールしてください。

```console
$ sudo apt install -y software-properties-common
$ sudo add-apt-repository -y universe
$ sudo add-apt-repository -y ppa:groonga/ppa
$ sudo apt update
Ubuntu 22.04:
$ sudo apt install -y -V postgresql-14-pgroonga
Ubuntu 24.04:
$ sudo apt install -y -V postgresql-16-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo apt install -y -V groonga-tokenizer-mecab
```

データベースを作成します。

```console
$ sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを利用するべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
$ sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。

## 公式PostgreSQL用のインストール方法 {#install-for-official-postgresql}

UbuntuでPostgreSQL Global Development Groupが提供するPostgreSQLパッケージ用にPGroongaをインストールする手順は次の通りです。

```console
$ sudo apt install -y -V ca-certificates lsb-release wget
$ wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
$ wget https://packages.groonga.org/ubuntu/groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo wget -O /usr/share/keyrings/pgdg.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc
$ (echo "Types: deb"; \
   echo "URIs: http://apt.postgresql.org/pub/repos/apt"; \
   echo "Suites: $(lsb_release --codename --short)-pgdg"; \
   echo "Components: main"; \
   echo "Signed-By: /usr/share/keyrings/pgdg.asc") | \
    sudo tee /etc/apt/sources.list.d/pgdg.sources
$ sudo apt update
$ sudo apt install -y -V postgresql-{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo apt install -y -V groonga-tokenizer-mecab
```

データベースを作成します。

```console
$ sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを利用するべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
$ sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
