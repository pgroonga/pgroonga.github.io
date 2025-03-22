---
title: Install on Debian GNU/Linux
---

# Install on Debian GNU/Linux

This document describes how to install PGroonga on Debian GNU/Linux.

## Supported versions

Here are supported Debian GNU/Linux versions:

  * [bookworm](#install-on-bookworm)

## How to install on Debian GNU/Linux bookworm {#install-on-bookworm}

You can use the following instruction to install PGroonga on Debian GNU/Linux bookworm.

Install `groonga-apt-source` package:

```console
$ sudo apt install -y -V ca-certificates lsb-release wget
$ wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
$ sudo apt update
```

If you want to use the PostgreSQL packages provided by PostgreSQL, you need to add [the APT repository by PostgreSQL][postgresql-apt]:

```console
$ sudo wget -O /usr/share/keyrings/pgdg.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc
$ (echo "Types: deb"; \
   echo "URIs: http://apt.postgresql.org/pub/repos/apt"; \
   echo "Suites: $(lsb_release --codename --short)-pgdg"; \
   echo "Components: main"; \
   echo "Signed-By: /usr/share/keyrings/pgdg.asc") | \
    sudo tee /etc/apt/sources.list.d/pgdg.sources
```

Install `postgresql-*-pgdg-pgroonga` package:

```console
$ sudo apt update
$ sudo apt install -y -V postgresql-17-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-16-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-15-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-14-pgdg-pgroonga
Or
$ sudo apt install -y -V postgresql-13-pgdg-pgroonga
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

[postgresql-apt]:https://www.postgresql.org/download/linux/debian/
