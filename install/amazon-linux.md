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

Install `postgresql{{ site.amazon_linux_postgresql_version.major }}` package:

We can't use PostgreSQL's Yum repository because of PostgreSQL doesn't provide a package for Amazon Linux.

Therefore, we modify PostgreSQL's `.repo` file as below.

```console
$ wget https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
$ sudo rpm -Uvh --nodeps pgdg-redhat-repo-latest.noarch.rpm
$ sudo sed --in-place -e "s/\$releasever/7/g" /etc/yum.repos.d/pgdg-redhat-all.repo
```

Install `postgresql{{ site.amazon_linux_postgresql_version.major }}-pgroonga` package:

We enable EPEL repository as below.

```console
$ sudo -H yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

We install yum repository for Groonga.

```console
$ sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
```

We install PGroonga

```console
$ sudo -H yum install -y postgresql{{ site.amazon_linux_postgresql_version.major }}-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```console
$ sudo -H /usr/pgsql-{{ site.amazon_linux_postgresql_version.major }}/bin/postgresql-{{ site.amazon_linux_postgresql_version.major }}-setup initdb
$ sudo -H systemctl enable postgresql-{{ site.amazon_linux_postgresql_version.major }}
$ sudo -H systemctl start postgresql-{{ site.amazon_linux_postgresql_version.major }}
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
