---
title: Uninstall
---

# Uninstall

次のSQLでPGroongaをアンインストールできます。

```sql
DROP EXTENSION pgroonga CASCADE;
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```

手動で`pg_catalog.pg_am`からPGroongaを削除しなければいけないのはおかしいかもしれません。もし、正しいSQLを知っていたら[教えてください](https://github.com/pgroonga/pgroonga/issues/new)。
