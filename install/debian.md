---
title: Install on Debian GNU/Linux
---

# Install on Debian GNU/Linux

This document describes how to install PGroonga on Debian GNU/Linux.

## Supported versions

Here are supported Debian GNU/Linux versions:

  * [Jessie](#install-on-jessie)

  * [Stretch](#install-on-stretch)

## How to install on Debian GNU/Linux Jessie {#install-on-jessie}

You can use the following instruction to install PGroonga on Debian GNU/Linux Jessie.

Install `apt-transport-https` package:

```console
% sudo apt update
% sudo apt install -y -V apt-transport-https
```

Add APT repository for Groonga:

`/etc/apt/sources.list.d/groonga.list`:

```text
deb https://packages.groonga.org/debian/ jessie main
deb-src https://packages.groonga.org/debian/ jessie main
```

Install `postgresql-9.4-pgroonga` package:

```console
% sudo apt update
% sudo apt install -y -V --allow-unauthenticated groonga-keyring
% sudo apt update
% sudo apt install -y -V postgresql-9.4-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
% sudo apt-get install -y -V groonga-tokenizer-mecab
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

## How to install on Debian GNU/Linux Stretch {#install-on-stretch}

You can use the following instruction to install PGroonga on Debian GNU/Linux Stretch.

Install `apt-transport-https` package:

```console
% sudo apt update
% sudo apt install -y -V apt-transport-https
```

Add APT repository for Groonga:

`/etc/apt/sources.list.d/groonga.list`:

```text
deb https://packages.groonga.org/debian/ stretch main
deb-src https://packages.groonga.org/debian/ stretch main
```

Install `postgresql-9.6-pgroonga` package:

```console
% sudo apt update
% sudo apt install -y -V --allow-unauthenticated groonga-keyring
% sudo apt update
% sudo apt install -y -V postgresql-9.6-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```console
% sudo apt-get install -y -V groonga-tokenizer-mecab
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
