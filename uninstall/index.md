---
title: Uninstall
---

# Uninstall

You can uninstall PGroonga by the following SQL:

```sql
DROP EXTENSION pgroonga CASCADE;
```
```

If you're using PostgreSQL 9.5 or earlier, you need to also run the following SQL:

```sql
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```
