---
title: Install on Amazon Linux
---

# Install on Amazon Linux

This document describes how to install PGroonga on Amazon Linux.

## Supported versions

Here are supported Amazon Linux versions:

  * [Amazon Linux 2](#install-on-2)

## How to install on Amazon Linux 2 {#install-on-2}

You can use the following instruction to install PGroonga on Amazon Linux 2.

Install `postgresql{{ site.amazon_linux_postgresql_version }}` package:

```console
% wget https://yum.postgresql.org/{{ site.amazon_linux_postgresql_version }}/redhat/rhel-7-x86_64/postgresql{{ site.amazon_linux_postgresql_version }}-server-{{ site.amazon_linux_postgresql_version }}.9-1PGDG.rhel7.x86_64.rpm
% wget https://yum.postgresql.org/{{ site.amazon_linux_postgresql_version }}/redhat/rhel-7-x86_64/postgresql{{ site.amazon_linux_postgresql_version }}-{{ site.amazon_linux_postgresql_version }}.9-1PGDG.rhel7.x86_64.rpm
% wget https://yum.postgresql.org/{{ site.amazon_linux_postgresql_version }}/redhat/rhel-7-x86_64/postgresql{{ site.amazon_linux_postgresql_version }}-libs-{{ site.amazon_linux_postgresql_version }}.9-1PGDG.rhel7.x86_64.rpm

% sudo -H yum install -y postgresql{{ site.amazon_linux_postgresql_version }}-*.rpm
```

Install `postgresql{{ site.amazon_linux_postgresql_version }}-pgroonga` package:

We enable EPEL repository as below.

```console
% sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
% sudo yum install -y epel-release
% sudo yum-config-manager --enable epel
```

We install yum repository for Groonga.

```console
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
```

We install PGroonga

```console
% sudo -H yum install -y postgresql{{ site.amazon_linux_postgresql_version }}-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
% sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```console
% sudo -H /usr/pgsql-{{ site.amazon_linux_postgresql_version }}/bin/postgresql-{{ site.amazon_linux_postgresql_version }}-setup initdb
% sudo -H systemctl enable postgresql-{{ site.amazon_linux_postgresql_version }}
% sudo -H systemctl start postgresql-{{ site.amazon_linux_postgresql_version }}
```

Create a database:

```console
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```console
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
