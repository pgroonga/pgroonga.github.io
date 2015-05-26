---
title: Install to Ubuntu
layout: en
---

# Install to Ubuntu

This document describes how to install PGroonga to Ubuntu.

## Supported versions

Here are supported Ubuntu versions:

  * Ubuntu 14.10
  * Ubuntu 15.04

## How to install

You can use the following instruction to install PGroonga to all supported Ubuntu versions.

Install `postgresql-server-9.4-pgroonga` package:

```text
% sudo apt-get install -y software-properties-common
% sudo add-apt-repository -y universe
% sudo add-apt-repository -y ppa:groonga/ppa
% sudo apt-get update
% sudo apt-get install -y postgresql-server-9.4-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo apt-get install -y groonga-tokenizer-mecab
```

Create a database:

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
