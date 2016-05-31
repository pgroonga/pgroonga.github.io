---
title: CentOSにインストール
---

# CnetOSにインストール

このドキュメントはPGroongaをCentOSにインストールする方法を説明します。

## サポートしているバージョン

サポートしているCentOSのバージョンは次の通りです。

  * [CentOS 5](#install-on-5-or-6)
  * [CentOS 6](#install-on-5-or-6)
  * [CentOS 7](#install-on-7)

## CentOS 5またはCentOS 6にインストールする方法 {#install-on-5-or-6}

次の方法でPGroongaをCentOS 5またはCentOS 6にインストールできます。

`postgresql-pgroonga`パッケージをインストールします。

```text
% sudo -H yum install -y http://yum.postgresql.org/9.5/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos95-9.5-2.noarch.rpm
% sudo -H yum install -y http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo -H yum makecache
% sudo -H yum install -y postgresql95-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```text
% sudo -H /sbin/service postgresql-9.5 initdb
% sudo -H /sbin/chkconfig postgresql-9.5 on
% sudo -H /sbin/service postgresql-9.5 start
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

## CentOS 7にインストールする方法 {#install-on-7}

CentOS 7にPGroongaをインストールする方法は次の通りです。

`postgresql-pgroonga`パッケージをインストールします。

```text
% sudo -H yum install -y http://yum.postgresql.org/9.5/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos95-9.5-2.noarch.rpm
% sudo -H yum install -y http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo -H yum makecache
% sudo -H yum install -y postgresql95-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```text
% sudo -H /usr/pgsql-9.5/bin/postgresql95-setup initdb
% sudo -H systemctl enable postgresql-9.5
% sudo -H systemctl start postgresql-9.5
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
