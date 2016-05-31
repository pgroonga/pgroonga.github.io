---
title: Uninstall
---

# Uninstall

You can uninstall PGroonga by the following SQL:

```sql
DROP EXTENSION pgroonga CASCADE;
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```

It may be strange that we need to remove the record for PGroonga from `pg_catalog.pg_am` by hand. If you know the correct SQL, [please tell us](https://github.com/pgroonga/pgroonga/issues/new).
