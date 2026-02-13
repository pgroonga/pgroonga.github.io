---
title: Debian GNU/Linuxにインストール
---

# Debian GNU/Linuxにインストール

このドキュメントはDebian GNU/LinuxにPGroongaをインストールする方法を説明します。

## サポートしているバージョン

サポートしているDebian GNU/Linuxのバージョンは次の通りです。

  * [trixie](#install-on-trixie)
  * [bookworm](#install-on-bookworm)

## Debian GNU/Linux trixieにインストールする方法 {#install-on-trixie}

Debian GNU/Linux trixieにPGroongaをインストールする方法は次の通りです。

`groonga-apt-source`パッケージをインストールします。

```console
$ sudo apt install -y -V ca-certificates lsb-release wget
$ wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt update
```

PostgreSQLが提供しているPostgreSQLパッケージを使いたい場合は[PostgreSQLが提供しているAPTリポジトリー][postgresql-apt]を追加します。

```console
$ sudo wget -O /usr/share/keyrings/pgdg.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc
$ (echo "Types: deb"; \
   echo "URIs: http://apt.postgresql.org/pub/repos/apt"; \
   echo "Suites: $(lsb_release --codename --short)-pgdg"; \
   echo "Components: main"; \
   echo "Signed-By: /usr/share/keyrings/pgdg.asc") | \
    sudo tee /etc/apt/sources.list.d/pgdg.sources
```

`postgresql-*-pgdg-pgroonga`パッケージをインストールします。

```console
$ sudo apt update
$ sudo apt install -y -V postgresql-18-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-17-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-16-pgdg-pgroonga
Or
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

セマンティックサーチ用に、[`<&@*>`演算子](https://pgroonga.github.io/ja/reference/operators/semantic-distance-v2.html) または、 [`&@*`演算子](https://pgroonga.github.io/ja/reference/operators/semantic-search-v2.html)を使いたい場合は、`groonga-plugin-language-model`パッケージもインストールする必要があります。

```console
$ sudo apt install -y -V groonga-plugin-language-model
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

## Debian GNU/Linux bookwormにインストールする方法 {#install-on-bookworm}

bookworm のインストール方法は、trixie のインストール方法と同じです。 [trixie](#install-on-trixie) を参照してください。

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。

[postgresql-apt]:https://www.postgresql.org/download/linux/debian/
