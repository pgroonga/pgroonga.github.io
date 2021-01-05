---
title: Install on CentOS
---

# Install on CentOS

This document describes how to install PGroonga on CentOS.

## Supported versions

Here are supported CentOS versions:

  * [CentOS 7](#install-on-7)

  * [CentOS 8](#install-on-8)

## How to install on CentOS 7 {#install-on-7}

You can use the following instruction to install PGroonga on CentOS 7.

Install `postgresql-pgroonga` package:

```console
$ sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
$ sudo -H yum install -y postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable postgresql-{{ site.latest_postgresql_version }}
$ sudo -H systemctl start postgresql-{{ site.latest_postgresql_version }}
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

## How to install on CentOS 8 {#install-on-8}

You can use the following instruction to install PGroonga on CentOS 8.

Note that WAL support is disabled for now.

Install `postgresql-pgroonga` package:

```console
$ sudo -H dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
$ sudo -H dnf install -y epel-release || sudo -H dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1).noarch.rpm
$ sudo -H dnf install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
$ sudo -H dnf module -y disable postgresql
$ sudo -H dnf install -y postgresql{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo -H dnf install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```console
$ sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
$ sudo -H systemctl enable postgresql-{{ site.latest_postgresql_version }}
$ sudo -H systemctl start postgresql-{{ site.latest_postgresql_version }}
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
