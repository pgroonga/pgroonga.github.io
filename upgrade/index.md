---
title: Upgrade
upper_level: ../
---

# Upgrade

You can upgrade PGroonga without recreating PGroonga indexes when new version doesn't have any backward incompatible change. If new version has any backward incompatible change, you need to recreate all PGroonga indexes to upgrade PGroonga.

Here is a list of compatibility:

  * 2.2.0 -> 2.2.1: Compatible

  * 2.1.9 -> 2.2.0: Compatible

  * 2.1.8 -> 2.1.9: Compatible

  * 2.1.7 -> 2.1.8: Compatible

  * 2.1.6 -> 2.1.7: Compatible

  * 2.1.4 -> 2.1.6: Compatible

  * 2.1.3 -> 2.1.4: Compatible

  * 2.1.2 -> 2.1.3: Compatible

  * 2.1.1 -> 2.1.2: Compatible

  * 2.1.0 -> 2.1.1: Compatible

  * 2.0.9 -> 2.1.0: Compatible

  * 2.0.8 -> 2.0.9: Compatible

  * 2.0.7 -> 2.0.8: Compatible

  * 2.0.6 -> 2.0.7: Compatible

  * 2.0.5 -> 2.0.6: Compatible

    * But you need to recreate your PGroonga indexes that use `timestamp (without time zone)`.

  * 2.0.4 -> 2.0.5: Compatible

  * 2.0.3 -> 2.0.4: Compatible

  * 2.0.2 -> 2.0.3: Compatible

    * But you need to recreate your PGroonga indexes that use `timestamp (without time zone)`.

    * But you need to recreate your PGroonga indexes that use [`pgroonga_text_array_full_text_search_ops_v2` operator class][text-array-full-text-search-ops-v2].

  * 2.0.1 -> 2.0.2: Compatible

  * 2.0.0 -> 2.0.1: Compatible

  * 1.2.3 -> 2.0.0: Compatible

  * 1.2.2 -> 1.2.3: Compatible

  * 1.2.1 -> 1.2.2: Compatible

  * 1.2.0 -> 1.2.1: Compatible

  * 1.1.9 -> 1.2.0: Compatible

  * 1.1.8 -> 1.1.9: Compatible

  * 1.1.7 -> 1.1.8: Compatible

  * 1.1.6 -> 1.1.7: Compatible

  * 1.1.5 -> 1.1.6: Compatible

  * 1.1.4 -> 1.1.5: Compatible

  * 1.1.3 -> 1.1.4: Compatible

  * 1.1.2 -> 1.1.3: Compatible

  * 1.1.1 -> 1.1.2: Compatible

  * 1.1.0 -> 1.1.1: Compatible

  * 1.0.9 -> 1.1.0: Compatible

  * 1.0.8 -> 1.0.9: Compatible

  * 1.0.7 -> 1.0.8: Compatible

  * 1.0.6 -> 1.0.7: Compatible

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
