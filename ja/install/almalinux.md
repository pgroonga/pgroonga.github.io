---
title: Install on AlmaLinux
---

# AlmaLinuxにインストール

このドキュメントは、PGroongaをAlmaLinuxにインストールする方法を説明します。

## サポートしているバージョン

サポートしているバージョンは次の通りです。

  * [AlmaLinux 10](#install-on-10)

  * [AlmaLinux 9](#install-on-9)

  * [AlmaLinux 8](#install-on-8)

## AlmaLinux 10にインストールする方法 {#install-on-10}

AlmaLinux 10にPGroongaをインストールする方法は次の通りです。

`postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga`パッケージをインストールします。

```console
$ sudo -H dnf install -y epel-release || sudo -H dnf install -y oracle-epel-release-el$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1) || sudo -H dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1).noarch.rpm
$ sudo -H dnf config-manager --set-enabled crb || :
$ sudo -H dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)-$(arch)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo dnf install -y https://packages.apache.org/artifactory/arrow/almalinux/$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)/apache-arrow-release-latest.rpm
$ sudo -H dnf install -y https://packages.groonga.org/almalinux/$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)/groonga-release-latest.noarch.rpm
$ sudo -H dnf install -y postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo -H dnf install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable --now postgresql-{{ site.latest_postgresql_version }}
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

## AlmaLinux 9にインストールする方法 {#install-on-9}

AlmaLinux 9のインストール方法は、AlmaLinux 10のインストール方法と同じです。 [AlmaLinux 10](#install-on-10) を参照してください。

## AlmaLinux 8にインストールする方法 {#install-on-8}

AlmaLinux 8にPGroongaをインストールする方法は次の通りです。

`postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga`パッケージをインストールします。

```console
$ sudo -H dnf module -y disable postgresql
$ sudo -H dnf install -y epel-release || sudo -H dnf install -y oracle-epel-release-el$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1) || sudo -H dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1).noarch.rpm
$ sudo -H dnf config-manager --set-enabled powertools || :
$ sudo -H dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)-$(arch)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo -H dnf install -y https://packages.groonga.org/almalinux/$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)/groonga-release-latest.noarch.rpm
$ sudo -H dnf install -y postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いたい場合は、`groonga-tokenizer-mecab`パッケージもインストールする必要があります。

```console
$ sudo -H dnf install -y groonga-tokenizer-mecab
```

PostgreSQLを実行します。

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable --now postgresql-{{ site.latest_postgresql_version }}
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
