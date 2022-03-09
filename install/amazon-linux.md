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

Install `postgresql{{ site.latest_amazon_linux_postgresql_version }}-package`:

```console
$ sudo -H amazon-linux-extras install -y epel postgresql{{ site.latest_amazon_linux_postgresql_version }}
$ sudo -H yum install -y ca-certificates
$ sudo -H yum install -y https://packages.groonga.org/amazon-linux/2/groonga-release-latest.noarch.rpm
$ sudo -H yum install -y postgresql{{ site.latest_amazon_linux_postgresql_version }}-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```console
$ sudo -H postgresql-setup initdb
$ sudo -H systemctl enable --now postgresql
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
