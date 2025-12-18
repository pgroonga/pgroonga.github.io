---
title: Install on AlmaLinux
---

# Install on AlmaLinux

This document describes how to install PGroonga on AlmaLinux.

## Supported versions

Here are supported AlmaLinux versions:

  * [AlmaLinux 10](#install-on-10)

  * [AlmaLinux 9](#install-on-9)

  * [AlmaLinux 8](#install-on-8)

## How to install on AlmaLinux 10 {#install-on-10}

You can use the following instruction to install PGroonga on AlmaLinux 10.

Install `postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga` package:

```console
$ sudo -H dnf install -y epel-release || sudo -H dnf install -y oracle-epel-release-el$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1) || sudo -H dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1).noarch.rpm
$ sudo -H dnf config-manager --set-enabled crb || :
$ sudo -H dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)-$(arch)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo dnf install -y https://packages.apache.org/artifactory/arrow/almalinux/$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)/apache-arrow-release-latest.rpm
$ sudo -H dnf install -y https://packages.groonga.org/almalinux/$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)/groonga-release-latest.noarch.rpm
$ sudo -H dnf install -y postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo -H dnf install -y groonga-tokenizer-mecab
```

If you want to use semantic search, you also need to install `groonga-plugin-language-model` package:

```console
$ sudo -H dnf install -y groonga-plugin-language-model
```

Run PostgreSQL:

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable --now postgresql-{{ site.latest_postgresql_version }}
```

Create a database:

```console
$ sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```console
$ sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.

## How to install on AlmaLinux 9 {#install-on-9}

On AlmaLinux 9, follow the same installation procedure as AlmaLinux 10. Please refer to [AlmaLinux 10](#install-on-10).

## How to install on AlmaLinux 8 {#install-on-8}

You can use the following instruction to install PGroonga on AlmaLinux 8.

*Semantic search is not supported on AlmaLinux 8.*

Install `postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga` package:

```console
$ sudo -H dnf module -y disable postgresql
$ sudo -H dnf install -y epel-release || sudo -H dnf install -y oracle-epel-release-el$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1) || sudo -H dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1).noarch.rpm
$ sudo -H dnf config-manager --set-enabled powertools || :
$ sudo -H dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)-$(arch)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo -H dnf install -y https://packages.groonga.org/almalinux/$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)/groonga-release-latest.noarch.rpm
$ sudo -H dnf install -y postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo -H dnf install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable --now postgresql-{{ site.latest_postgresql_version }}
```

Create a database:

```console
$ sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```console
$ sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
