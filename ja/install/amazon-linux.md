---
title: Amazon Linux にインストール
---

# Amazon Linux にインストール

このドキュメントはPGroongaをAmazon Linuxにインストールする方法を説明します。

## サポートしているバージョン

サポートしているAmazon Linuxのバージョンは次の通りです。

  * [Amazon Linux 2](#install-on-2)

## Amazon Linux 2 にインストールする方法 {#install-on-2}

Amazon Linux 2にPGroongaをインストールする方法は次の通りです。

`postgresql{{ site.amazon_linux_postgresql_version.major }}`パッケージをインストールします。

PostgreSQLはAmazon Linux用のパッケージを提供していないため、PostgreSQLのYumリポジトリは使用できません。

したがって、以下のようにPostgreSQLの`.repo`ファイルを変更します。

```console
$ wget https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
$ sudo rpm -Uvh --nodeps pgdg-redhat-repo-latest.noarch.rpm
$ sudo sed --in-place -e "s/\$releasever/7/g" /etc/yum.repos.d/pgdg-redhat-all.repo
```

`postgresql{{ site.amazon_linux_postgresql_version.major }}-pgroonga`パッケージをインストールします。

以下のようにEPELリポジトリを有効にします。

```console
$ sudo -H yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

Groonga用のyumリポジトリをインストールします。

```console
$ sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
```

PGroongaをインストールします。

```console
$ sudo -H yum install -y postgresql{{ site.amazon_linux_postgresql_version.major }}-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```console
$ sudo -H /usr/pgsql-{{ site.amazon_linux_postgresql_version.major }}/bin/postgresql-{{ site.amazon_linux_postgresql_version.major }}-setup initdb
$ sudo -H systemctl enable postgresql-{{ site.amazon_linux_postgresql_version.major }}
$ sudo -H systemctl start postgresql-{{ site.amazon_linux_postgresql_version.major }}
```

データベースを作成します。

```console
$ sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
$ sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
