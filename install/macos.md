---
title: Install on macOS
---

# Install on macOS

This document describes how to install PGroonga on macOS.

## How to install by Homebrew {#homebrew}

You can install PGroonga by Homebrew:

```console
$ brew install pgroonga
```

Create a database:

```console
$ psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```console
$ psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
