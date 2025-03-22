---
title: Install on Ubuntu
---

# Install on Ubuntu

This document describes how to install PGroonga on Ubuntu.

## Supported versions

Here are supported Ubuntu versions:

  * Ubuntu 24.04

  * Ubuntu 22.04

## How to install for system PostgreSQL {#install-for-system-postgresql}

You can use the following instruction to install PGroonga for system PostgreSQL on Ubuntu.

If you're using Ubuntu 22.04, install `postgresql-14-pgroonga` package:

If you're using Ubuntu 24.04, install `postgresql-16-pgroonga` package:

```console
$ sudo apt install -y software-properties-common
$ sudo add-apt-repository -y universe
$ sudo add-apt-repository -y ppa:groonga/ppa
$ sudo apt update
Ubuntu 22.04:
$ sudo apt install -y -V postgresql-14-pgroonga
Ubuntu 24.04:
$ sudo apt install -y -V postgresql-16-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo apt install -y -V groonga-tokenizer-mecab
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

## How to install for the official PostgreSQL {#install-for-official-postgresql}

You can use the following instruction to install PGroonga for the PostgreSQL packages provided by the PostgreSQL Global Development Group on Ubuntu.

```console
$ sudo apt install -y -V ca-certificates lsb-release wget
$ wget https://packages.groonga.org/ubuntu/groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo wget -O /usr/share/keyrings/pgdg.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc
$ (echo "Types: deb"; \
   echo "URIs: http://apt.postgresql.org/pub/repos/apt"; \
   echo "Suites: $(lsb_release --codename --short)-pgdg"; \
   echo "Components: main"; \
   echo "Signed-By: /usr/share/keyrings/pgdg.asc") | \
    sudo tee /etc/apt/sources.list.d/pgdg.sources
$ sudo apt update
$ sudo apt install -y -V postgresql-{{ site.latest_postgresql_version }}-pgdg-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
$ sudo apt install -y -V groonga-tokenizer-mecab
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
