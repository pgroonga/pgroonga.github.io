---
title: CentOSにインストール
---

# CentOSにインストール

このドキュメントはPGroongaをCentOSにインストールする方法を説明します。

## サポートしているバージョン

サポートしているCentOSのバージョンは次の通りです。

  * [CentOS 6](#install-on-6)

  * [CentOS 7](#install-on-7)

## CentOS 6にインストールする方法 {#install-on-6}

CentOS 6にPGroongaをインストールする方法は次の通りです。

`postgresql-pgroonga`パッケージをインストールします。

```text
% sudo -H yum install -y http://yum.postgresql.org/10/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos10-10-2.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y postgresql10-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```text
% sudo -H /sbin/service postgresql-10 initdb
% sudo -H /sbin/chkconfig postgresql-10 on
% sudo -H /sbin/service postgresql-10 start
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
% sudo -H yum install -y http://yum.postgresql.org/10/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos10-10-2.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y postgresql10-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```text
% sudo -H /usr/pgsql-10/bin/postgresql-10-setup initdb
% sudo -H systemctl enable postgresql-10
% sudo -H systemctl start postgresql-10
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
