---
title: CentOSにインストール
---

# CentOSにインストール

このドキュメントはPGroongaをCentOSにインストールする方法を説明します。

## サポートしているバージョン

サポートしているCentOSのバージョンは次の通りです。

  * [CentOS 7](#install-on-7)

  * [CentOS 8](#install-on-8)

## CentOS 7にインストールする方法 {#install-on-7}

CentOS 7にPGroongaをインストールする方法は次の通りです。

`postgresql-pgroonga`パッケージをインストールします。

```console
$ sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
$ sudo -H yum install -y postgresql{{ site.latest_postgresql_version }}-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable postgresql-{{ site.latest_postgresql_version }}
$ sudo -H systemctl start postgresql-{{ site.latest_postgresql_version }}
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

## CentOS 8にインストールする方法 {#install-on-8}

CentOS 8にPGroongaをインストールする方法は次の通りです。

今のところWALサポートは無効になっています。

`postgresql-pgroonga`パッケージをインストールします。

```console
$ sudo -H dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(cut -d: -f5 /etc/system-release-cpe)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo -H dnf install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
$ sudo -H dnf module -y disable postgresql
$ sudo -H dnf install -y postgresql{{ site.latest_postgresql_version }}-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo -H dnf install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable postgresql-{{ site.latest_postgresql_version }}
$ sudo -H systemctl start postgresql-{{ site.latest_postgresql_version }}
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
