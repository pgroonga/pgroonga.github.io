---
title: Uninstall
---

# Uninstall

次のSQLでPGroongaをアンインストールできます。

```sql
DROP EXTENSION pgroonga CASCADE;
```
```

PostgreSQL 9.5以前を使っている場合は以下のSQLも実行する必要があります。

```sql
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```
