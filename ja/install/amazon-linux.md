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

`postgresql{{ site.amazon_linux_postgresql_version }}`パッケージをインストールします。

PostgreSQLはAmazon Linux用のパッケージを提供していないため、PostgreSQLのYumリポジトリは使用できません。

したがって、以下のようにPostgreSQLのRPMを直接インストールします。

```console
% wget https://yum.postgresql.org/{{ site.amazon_linux_postgresql_version }}/redhat/rhel-7-x86_64/postgresql{{ site.amazon_linux_postgresql_version }}-server-{{ site.amazon_linux_postgresql_version }}.9-1PGDG.rhel7.x86_64.rpm
% wget https://yum.postgresql.org/{{ site.amazon_linux_postgresql_version }}/redhat/rhel-7-x86_64/postgresql{{ site.amazon_linux_postgresql_version }}-{{ site.amazon_linux_postgresql_version }}.9-1PGDG.rhel7.x86_64.rpm
% wget https://yum.postgresql.org/{{ site.amazon_linux_postgresql_version }}/redhat/rhel-7-x86_64/postgresql{{ site.amazon_linux_postgresql_version }}-libs-{{ site.amazon_linux_postgresql_version }}.9-1PGDG.rhel7.x86_64.rpm

% sudo -H yum install -y postgresql{{ site.amazon_linux_postgresql_version }}-*.rpm
```

`postgresql{{ site.amazon_linux_postgresql_version }}-pgroonga`パッケージをインストールしまうす。

以下のようにEPELリポジトリを有効にします。

```console
% sudo -H yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

Groonga用のyumリポジトリをインストールします。

```console
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
```

PGroongaをインストールします。

```console
% sudo -H yum install -y postgresql{{ site.amazon_linux_postgresql_version }}-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
% sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```console
% sudo -H /usr/pgsql-{{ site.amazon_linux_postgresql_version }}/bin/postgresql-{{ site.amazon_linux_postgresql_version }}-setup initdb
% sudo -H systemctl enable postgresql-{{ site.amazon_linux_postgresql_version }}
% sudo -H systemctl start postgresql-{{ site.amazon_linux_postgresql_version }}
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
