---
title: Install on Ubuntu
---

# Install on Ubuntu

This document describes how to install PGroonga on Ubuntu.

## Supported versions

Here are supported Ubuntu versions:

  * Ubuntu 16.04

  * Ubuntu 18.04

  * Ubuntu 18.10

  * Ubuntu 19.04

  * Ubuntu 19.10

## How to install

You can use the following instruction to install PGroonga on Ubuntu.

If you're using Ubuntu 16.04, install `postgresql-9.5-pgroonga` package.

If you're using Ubuntu 19.04 or 19.10, install `postgresql-11-pgroonga` package.

Otherwise, install `postgresql-10-pgroonga` package:

```text
% sudo apt install -y software-properties-common
% sudo add-apt-repository -y universe
% sudo add-apt-repository -y ppa:groonga/ppa
% sudo apt-get update
Ubuntu 16.04:
% sudo apt install -y -V postgresql-9.5-pgroonga
Ubuntu 19.04 or 19.10:
% sudo apt install -y -V postgresql-11-pgroonga
Others:
% sudo apt install -y -V postgresql-10-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo apt install -y -V groonga-tokenizer-mecab
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
