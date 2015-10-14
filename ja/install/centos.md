---
title: CentOSにインストール
layout: ja
---

# CnetOSにインストール

このドキュメントはPGroongaをCentOSにインストールする方法を説明します。

## サポートしているバージョン

サポートしているCentOSのバージョンは次の通りです。

  * [CentOS 5](#install-on-5-or-6)
  * [CentOS 6](#install-on-5-or-6)
  * [CentOS 7](#install-on-7)

{: #install-on-5-or-6}

## CentOS 5またはCentOS 6にインストールする方法

次の方法でPGroongaをCentOS 5またはCentOS 6にインストールできます。

`postgresql-pgroonga`パッケージをインストールします。

```text
% sudo rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos94-9.4-1.noarch.rpm
% sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo yum makecache
% sudo yum install -y postgresql94-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```text
% sudo -H /sbin/service postgresql-9.4 initdb
% sudo -H /sbin/chkconfig postgresql-9.4 on
% sudo -H /sbin/service postgresql-9.4 start
```

データベースを作成します。

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。

{: #install-on-7}

## CentOS 7にインストールする方法

CentOS 7にPGroongaをインストールする方法は次の通りです。

`postgresql-pgroonga`パッケージをインストールします。

```text
% sudo rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos94-9.4-1.noarch.rpm
% sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo yum makecache
% sudo yum install -y postgresql94-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```text
% sudo -H /usr/pgsql-9.4/bin/postgresql94-setup initdb
% sudo -H systemctl enable postgresql-9.4
% sudo -H systemctl start postgresql-9.4
```

データベースを作成します。

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
