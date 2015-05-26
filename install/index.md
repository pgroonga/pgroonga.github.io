---
title: Install
layout: en
---

# Install

There are packages for major platforms. You can install PGroonga easily.

There are separated documents for these platforms. And there is a document for building PGroonga from source.

Here are supported PostgreSQL versions:

  * 9.3
  * 9.4

If your PostgreSQL is older than them, you need to upgrade your PostgreSQL before you install PGroonga.

See a document for your platform in the followings:

  * [Ubuntu](ubuntu.html)
    * 14.10
    * 15.04
  * [CentOS](centos.html)
    * 5
    * 6
    * 7
  * [Windows](windows.html)
    * 32bit + PostgreSQL {{ site.windows_postgresql_version }}
    * 64bit + PostgreSQL {{ site.windows_postgresql_version }}

If you can't find your platform in the above list, [build and install from source](source.html).

## Uninstall

You can uninstall PGroonga by the following SQL:

```sql
DROP EXTENSION pgroonga CASCADE;
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```

It may be strange that we need to remove the record for PGroonga from `pg_catalog.pg_am` by hand. If you know the correct SQL, please tell us.
