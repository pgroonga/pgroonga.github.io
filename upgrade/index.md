---
title: Upgrade
upper_level: ../
---

# Upgrade

You can upgrade PGroonga without recreating PGroonga indexes when new version doesn't have any backward incompatible change. If new version has any backward incompatible change, you need to recreate all PGroonga indexes to upgrade PGroonga.

Here is a list of compatibility ("o" means "compatible" and "x" means "incompatible"):

  * 3.0.8 -> 3.0.9: o

  * 3.0.7 -> 3.0.8: o

  * 3.0.6 -> 3.0.7: o

  * 3.0.5 -> 3.0.6: o

  * 3.0.4 -> 3.0.5: o

  * 3.0.3 -> 3.0.4: o

  * 3.0.2 -> 3.0.3: o

  * 3.0.1 -> 3.0.2: o

  * 3.0.0 -> 3.0.1: o

  * 2.4.7 -> 3.0.0: x

    * If you don't use v1 API, 2.4.7 -> 3.0.0 is compatible. So most users must be compatible.

  * 2.4.6 -> 2.4.7: o

  * 2.4.5 -> 2.4.6: o

  * 2.4.4 -> 2.4.5: o

  * 2.4.3 -> 2.4.4: o

  * 2.4.2 -> 2.4.3: o

  * 2.4.1 -> 2.4.2: o

  * 2.4.0 -> 2.4.1: o

  * 2.3.9 -> 2.4.0: o

  * 2.3.8 -> 2.3.9: o

  * 2.3.7 -> 2.3.8: o

  * 2.3.6 -> 2.3.7: o

  * 2.3.5 -> 2.3.6: o

  * 2.3.4 -> 2.3.5: o

  * 2.3.3 -> 2.3.4: o

  * 2.3.2 -> 2.3.3: o

  * 2.3.1 -> 2.3.2: o

  * 2.3.0 -> 2.3.1: o

  * 2.2.9 -> 2.3.0: o

  * 2.2.8 -> 2.2.9: o

  * 2.2.7 -> 2.2.8: o

  * 2.2.6 -> 2.2.7: o

  * 2.2.5 -> 2.2.6: o

    * But you need to recreate your PGroonga indexes that use `jsonb`.

  * 2.2.4 -> 2.2.5: o

  * 2.2.3 -> 2.2.4: o

  * 2.2.2 -> 2.2.3: o

  * 2.2.1 -> 2.2.2: o

  * 2.2.0 -> 2.2.1: o

  * 2.1.9 -> 2.2.0: o

  * 2.1.8 -> 2.1.9: o

  * 2.1.7 -> 2.1.8: o

  * 2.1.6 -> 2.1.7: o

  * 2.1.4 -> 2.1.6: o

  * 2.1.3 -> 2.1.4: o

  * 2.1.2 -> 2.1.3: o

  * 2.1.1 -> 2.1.2: o

  * 2.1.0 -> 2.1.1: o

  * 2.0.9 -> 2.1.0: o

  * 2.0.8 -> 2.0.9: o

  * 2.0.7 -> 2.0.8: o

  * 2.0.6 -> 2.0.7: o

  * 2.0.5 -> 2.0.6: o

    * But you need to recreate your PGroonga indexes that use `timestamp (without time zone)`.

  * 2.0.4 -> 2.0.5: o

  * 2.0.3 -> 2.0.4: o

  * 2.0.2 -> 2.0.3: o

    * But you need to recreate your PGroonga indexes that use `timestamp (without time zone)`.

    * But you need to recreate your PGroonga indexes that use [`pgroonga_text_array_full_text_search_ops_v2` operator class][text-array-full-text-search-ops-v2].

  * 2.0.1 -> 2.0.2: o

  * 2.0.0 -> 2.0.1: o

  * 1.2.3 -> 2.0.0: o

  * 1.2.2 -> 1.2.3: o

  * 1.2.1 -> 1.2.2: o

  * 1.2.0 -> 1.2.1: o

  * 1.1.9 -> 1.2.0: o

  * 1.1.8 -> 1.1.9: o

  * 1.1.7 -> 1.1.8: o

  * 1.1.6 -> 1.1.7: o

  * 1.1.5 -> 1.1.6: o

  * 1.1.4 -> 1.1.5: o

  * 1.1.3 -> 1.1.4: o

  * 1.1.2 -> 1.1.3: o

  * 1.1.1 -> 1.1.2: o

  * 1.1.0 -> 1.1.1: o

  * 1.0.9 -> 1.1.0: o

  * 1.0.8 -> 1.0.9: o

  * 1.0.7 -> 1.0.8: o

  * 1.0.6 -> 1.0.7: o

  * 1.0.5 -> 1.0.6: o

  * 1.0.4 -> 1.0.5: o

  * 1.0.3 -> 1.0.4: o

  * 1.0.2 -> 1.0.3: o

  * 1.0.1 -> 1.0.2: o

  * 1.0 -> 1.0.1: o

  * 0.9 -> 1.0: x

  * 0.8 -> 0.9: o

  * 0.7 -> 0.8: x

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

  1. Disconnect from all databases that use PGroonga.

  1. Upgrade PGroonga binary.

  1. Connect to a database that uses PGroonga.

  1. Upgrade PGroonga extension.

You can upgrade PGroonga binary by package. Or you can upgrade by building new PGroonga and override old PGroonga.

Here is a SQL that upgrades PGroonga:

```sql
ALTER EXTENSION pgroonga UPDATE;
```

If you're using [`pgroonga_database` module][pgroonga-database], you also need to run the following SQL to upgrade `pgroonga_database` module:

```sql
ALTER EXTENSION pgroonga_database UPDATE;
```

## See also

  * [`CREATE EXTENSION`]({{ site.postgresql_doc_base_url.en }}/sql-createextension.html)

  * [`DROP EXTENSION`]({{ site.postgresql_doc_base_url.en }}/sql-dropextension.html)

  * [`ALTER EXTENSION`]({{ site.postgresql_doc_base_url.en }}/sql-alterextension.html)

  * [`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)

[text-array-full-text-search-ops-v2]:../reference/#text-array-full-text-search-ops-v2

[pgroonga-database]:../reference/modules/pgroonga-database.html
