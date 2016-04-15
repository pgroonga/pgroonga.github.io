---
title: Upgrade
layout: en
---

# Upgrade

You can upgrade PGroonga without recreating PGroonga indexes when new version doesn't have any backward incompatible change. If new version has any backward incompatible change, you need to recreate all PGroonga indexes to upgrade PGroonga.

Here is a list of compatibility:

  * 1.0.5 -> 1.0.6: Compatible

  * 1.0.4 -> 1.0.5: Compatible

  * 1.0.3 -> 1.0.4: Compatible

  * 1.0.2 -> 1.0.3: Compatible

  * 1.0.1 -> 1.0.2: Compatible

  * 1.0 -> 1.0.1: Compatible

  * 0.9 -> 1.0: Incompatible

  * 0.8 -> 0.9: Compatible

  * 0.7 -> 0.8: Incompatible

## Incompatible case {#incompatible-case}

Here are steps to upgrade:

  1. Drop all PGroonga indexes.

  1. Drop PGroonga extension.

  1. Upgrade PGroonga binary.

  1. Install PGroonga extension.

  1. Create all PGroonga indexes again.

Here is a SQL that drops all PGroonga indexes and PGroonga extension:

```sql
DROP EXTENSION pgroonga CASCADE;
```

You can upgrade PGroonga binary by package. Or you can upgrade by building new PGroonga and override old PGroonga.

Here is a SQL that install PGroonga extension:

```sql
CREATE EXTENSION pgroonga;
```

Use [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html) to create PGroonga indexes.

## Compatible case {#compatible-case}

Here are steps to upgrade:

  1. Upgrade PGroonga binary.

  1. Upgrade PGroonga extension.

You can upgrade PGroonga binary by package. Or you can upgrade by building new PGroonga and override old PGroonga.

Here is a SQL that upgrades PGroonga:

```sql
ALTER EXTENSION pgroonga UPDATE;
```

## See also

  * [`CREATE EXTENSION`](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/sql-createextension.html)

  * [`DROP EXTENSION`](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/sql-dropextension.html)

  * [`ALTER EXTENSION`](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/sql-alterextension.html)

  * [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)
