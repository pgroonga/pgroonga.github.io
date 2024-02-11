---
title: Debian GNU/Linuxにインストール
---

# Debian GNU/Linuxにインストール

このドキュメントはDebian GNU/LinuxにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているDebian GNU/Linuxのバージョンは次の通りです。

  * [bookworm](#install-on-bookworm)

  * [bullseye](#install-on-bullseye)

## Debian GNU/Linux bookwormにインストールする方法 {#install-on-bookworm}

Debian GNU/Linux bookwormにPGroongaをインストールする方法は次の通りです。

`groonga-apt-source`パッケージをインストールします。

```console
$ sudo apt install -y -V ca-certificates lsb-release wget
$ wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
$ wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt update
```

PostgreSQLが提供しているPostgreSQLパッケージを使いたい場合は[PostgreSQLが提供しているAPTリポジトリー][postgresql-apt]を追加します。

```console
$ echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release --codename --short)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

`postgresql-*-pgdg-pgroonga`パッケージをインストールします。

```console
$ sudo apt update
$ sudo apt install -y -V postgresql-15-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-14-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-13-pgdg-pgroonga
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

## Debian GNU/Linux bullseyeにインストールする方法 {#install-on-bullseye}

Debian GNU/Linux bullseyeにPGroongaをインストールする方法は次の通りです。

`groonga-apt-source`パッケージをインストールします。

```console
$ sudo apt install -y -V wget
$ wget https://packages.groonga.org/debian/groonga-apt-source-latest-bullseye.deb
$ sudo apt install -y -V ./groonga-apt-source-latest-bullseye.deb
```

PostgreSQLが提供しているPostgreSQLパッケージを使いたい場合は[PostgreSQLが提供しているAPTリポジトリー][postgresql-apt]を追加します。

```console
$ echo "deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

`postgresql-*-pgdg-pgroonga`パッケージをインストールします。

```console
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

[postgresql-apt]:https://www.postgresql.org/download/linux/debian/
