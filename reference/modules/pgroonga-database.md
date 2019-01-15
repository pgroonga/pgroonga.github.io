---
title: pgroonga_database module
upper_level: ../
---

# `pgroonga_database` module

Since 2.1.8.

## Summary

`pgroonga_database` module provides functions that manage PGroonga database. Normally, you don't need to use this module.

Note that this module provides dangerous functions. You should not enable this module until you need this module.

## Usage

You can install `pgroonga_database` module as an extension but you should care which users can use functions provided by this module.

You can restrict users who can use functions provided by this module by schema.

Here is an example to restrict user "admin" by creating `pgroonga_admin` schema and installing `pgroonga_database` module to the `pgroonga_admin` schema:

```sql
CREATE ROLE admin LOGIN;
CREATE SCHEMA pgroonga_admin AUTHORIZATION admin;
CREATE EXTENSION pgroonga_database SCHEMA pgroonga_admin;
```

In this example, users except the "admin" can't use functions provided by this module.

The "admin" user can use functions provided by this module with `pgroonga_admin.` prefix:

```sql
SELECT pgroonga_admin.pgoronga_database_remove();
```

See [upgrade][upgrade] document for upgrading `pgroonga_database` module.

## Functions

`pgroonga_database` module provides the following functions:

  * [`pgroonga_database_remove` function][database-remove]

[database-remove]:../functions/pgroonga-database-remove.html

[upgrade]:../../upgrade/
