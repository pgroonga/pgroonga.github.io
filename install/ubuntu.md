---
title: Install on Ubuntu
layout: en
---

# Install on Ubuntu

This document describes how to install PGroonga on Ubuntu.

## Supported versions

Here are supported Ubuntu versions:

  * Ubuntu 14.04
  * Ubuntu 15.04
  * Ubuntu 15.10
  * Ubuntu 16.04

## How to install

You can use the following instruction to install PGroonga on Ubuntu.

If you're using Ubuntu 14.04, install `postgresql-9.3-pgroonga` package.

If you're using Ubuntu 15.04 or 15.10, install `postgresql-9.4-pgroonga` package.

Otherwise, install `postgresql-9.5-pgroonga` package:

```text
% sudo apt-get install -y software-properties-common
% sudo add-apt-repository -y universe
% sudo add-apt-repository -y ppa:groonga/ppa
% sudo apt-get update
Ubuntu 14.04:
% sudo apt-get install -y -V postgresql-9.3-pgroonga
Ubuntu 15.04 or 15.10:
% sudo apt-get install -y -V postgresql-9.4-pgroonga
Others:
% sudo apt-get install -y -V postgresql-9.5-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo apt-get install -y -V groonga-tokenizer-mecab
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
