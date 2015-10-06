---
title: "%% operator"
layout: en
---

# `%%` operator

You can do full text search with one keyword by `%%` operator:

```sql
SELECT * FROM memos WHERE content %% '全文検索';
--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 行)
```

If you want to do full text search with multiple keywords or AND/OR search, use [`%%` operator](query.html).
