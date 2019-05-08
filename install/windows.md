---
title: Install on Windows
---

# Install on Windows

This document describes how to install PGroonga on Windows.

## Supported versions

You can use both 32bit version Windows and 64bit version Windows. You can use any Windows that are supported by PostgreSQL.

## How to install

Install PostgreSQL (supported versions: {{ site.windows_postgresql_versions | join: ", " }}). You can choose [installer version](http://www.enterprisedb.com/products-services-training/pgdownload) or [zip version](http://www.enterprisedb.com/products-services-training/pgbindownload).

Download PGroonga package:

{% for windows_postgresql_version in site.windows_postgresql_versions %}

{% assign windows_postgresql_major_version = windows_postgresql_version | split: "." | first %}
{% if windows_postgresql_major_version == "9" or
      windows_postgresql_major_version == "10" %}

  * [For PostgreSQL {{ windows_postgresql_version }} 32bit version](https://github.com/pgroonga/pgroonga/releases/download/{{ site.pgroonga_version }}/pgroonga-{{ site.pgroonga_version }}-postgresql-{{ windows_postgresql_version }}-x86.zip)

{% endif %}

  * [For PostgreSQL {{ windows_postgresql_version }} 64bit version](https://github.com/pgroonga/pgroonga/releases/download/{{ site.pgroonga_version }}/pgroonga-{{ site.pgroonga_version }}-postgresql-{{ windows_postgresql_version }}-x64.zip)

{% endfor %}

Extract the downloaded PGroonga package. You need to specify PostgreSQL folder as extract target folder.

If you installed installer version PostgreSQL, `C:\Program Files\PostgreSQL\%POSTGRESQL_VERSION%` is the extract target folder.

If you installed zip version PostgreSQL, `%POSTGRESQL_ZIP_EXTRACTED_FOLDER%\pgsql` is the extract target folder.

Create a database:

```text
postgres=# CREATE DATABASE pgroonga_test;
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
postgres=# \c pgroonga_test
pgroonga_test=# CREATE EXTENSION pgroonga;
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
