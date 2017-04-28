---
title: Install
---

# Install

There are packages for major platforms. You can install PGroonga easily.

There are separated documents for these platforms. And there is a document for building PGroonga from source.

Here are supported PostgreSQL versions:

  * 9.3
  * 9.4
  * 9.5
  * 9.6

If your PostgreSQL is older than them, you need to upgrade your PostgreSQL before you install PGroonga.

See a document for your platform in the followings:

  * [Debian GNU/Linux](debian.html)

    * Jessie

  * [Ubuntu](ubuntu.html)

    * 14.04

    * 16.04

    * 16.10

    * 17.04

  * [CentOS](centos.html)

    * 5

    * 6

    * 7

  * [FreeBSD](freebsd.html)

  * [OS X](os-x.html)

    * Homebrew

  * [Windows](windows.html)

{% for windows_postgresql_version in site.windows_postgresql_versions %}

    * 32bit + PostgreSQL {{ windows_postgresql_version }}

    * 64bit + PostgreSQL {{ windows_postgresql_version }}

{% endfor %}

If you can't find your platform in the above list, [build and install from source](source.html) or send a request as an [issue](https://github.com/pgroonga/pgroonga/issues/new).

## Uninstall

You can uninstall PGroonga by the following SQL:

```sql
DROP EXTENSION pgroonga CASCADE;
```

If you're using PostgreSQL 9.5 or earlier, you need to also run the following SQL:

```sql
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```
