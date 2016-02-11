---
title: Install on OS X
layout: en
---

# Install on OS X

This document describes how to install PGroonga on OS X.

## How to install by Homebrew {#homebrew}

You can install PGroonga by Homebrew:

```text
% brew install pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you need to reinstall `groonga` package with `--with-mecab` option:

```text
% brew reinstall groonga --with-mecab
```

Create a database:

```text
% psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
