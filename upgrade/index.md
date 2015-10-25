---
title: Upgrade
layout: en
---

# Upgrade

If you installed your PGroonga by package, install new PGroonga by package manager.

If you installed your PGroonga by building PGroonga by yourself, build new PGroonga and override old PGroonga.

Run the following SQL in your database that uses PGroonga after you replace old PGroonga binary with new PGroonga binary:

```sql
ALTER EXTENSION pgroonga UPDATE;
```

It upgrades PGroonga configurations.

## See also

  * [`ALTER EXTENSION`](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/sql-alterextension.html)
