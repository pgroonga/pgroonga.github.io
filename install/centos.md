---
title: Install on CentOS
---

# Install on CentOS

This document describes how to install PGroonga on CentOS.

## Supported versions

Here are supported CentOS versions:

  * [CentOS 6](#install-on-6)

  * [CentOS 7](#install-on-7)

## How to install on CentOS 6 {#install-on-6}

You can use the following instruction to install PGroonga on CentOS 6.

Install `postgresql-pgroonga` package:

```text
% sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y postgresql{{ site.latest_postgresql_version }}-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```text
% sudo -H /sbin/service postgresql-{{ site.latest_postgresql_version }} initdb
% sudo -H /sbin/chkconfig postgresql-{{ site.latest_postgresql_version }} on
% sudo -H /sbin/service postgresql-{{ site.latest_postgresql_version }} start
```

Create a database:

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.

## How to install on CentOS 7 {#install-on-7}

You can use the following instruction to install PGroonga on CentOS 7.

Install `postgresql-pgroonga` package:

```text
% sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y postgresql{{ site.latest_postgresql_version }}-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```text
% sudo -H /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
% sudo -H systemctl enable postgresql-{{ site.latest_postgresql_version }}
% sudo -H systemctl start postgresql-{{ site.latest_postgresql_version }}
```

Create a database:

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
