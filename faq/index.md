---
title: FAQ
---

# FAQ

## PGroonga fails to initialize {#fail-initialize}

These are some reasons why PGroonga fails to initialize:

  * [SELinux](#selinux)

If the issue is fixed and PGroonga still returns `pgroonga: already tried to initialize and failed`, please restart PostgreSQL so failed/corrupt `<data dir>/pgrn*` files can be detected and removed.

### SELinux {#selinux}

If you use SELinux then PGroonga needs a policy package. The section [building PGroonga from source](../install/source.html) shows how to create one.

Before installing the policy package, perhaps your PGroonga installation had failed due to incorrect SELinux permissions. In this case, you must restart PostgreSQL to clean PGroonga failed/corrupt files.

## Managed service including PGroonga {#managed-pgroonga}

There is a DBaaS that includes PGroonga:

### Supabase

[Supabase](https://supabase.com/) is an open source Firebase alternative that provides all the backend features developers need to build a product: a PostgreSQL database, Authentication, instant APIs, Edge Functions, Realtime subscriptions, and Storage.

PostgreSQL is the core of Supabase, it works natively with more than 40 PostgreSQL extensions, including PGroonga.

## PGroonga Indexes FAQ

**Q: I created a PGroonga index, but my searches are still slow.**

**A:** When a search is slow, it often means PostgreSQL is using a sequential scan instead of the PGroonga index. To check this, run your query with `EXPLAIN ANALYZE`. If you see "Seq Scan" in the output, it indicates the system is not utilizing the index. The goal is to see "Index Scan using pgrn_content_index" or similar, indicating the index is being used. Check the table configuration to confirm that PGroonga indexes are properly set.
<details>
  <summary>To confirm whether a sequential search is being executed</summary>
  We use a following table structure as an example. To ensure the search is definitely sequential in this example, no indexes or primary keys have been set.

```sql
CREATE TABLE memos (
  title text,
  content text
);

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is an RDBMS.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is a super-fast full-text search engine.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension that brings super-fast full-text search to PostgreSQL.');
```

The query we are examining is as follows:

```sql
SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
```

Now, let's confirm whether the query is using a sequential search. As mentioned earlier, we'll use `EXPLAIN ANALYZE` to check.

```sql
EXPLAIN ANALYZE SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
--                                              QUERY PLAN                                              
-- -----------------------------------------------------------------------------------------------------
--  Seq Scan on memos  (cost=0.00..678.80 rows=1 width=64) (actual time=2.803..4.664 rows=2 loops=1)
--    Filter: (content &@~ 'PostgreSQL'::text)
--    Rows Removed by Filter: 1
--  Planning Time: 0.113 ms
--  Execution Time: 4.731 ms
-- (5 rows)
```

The result is as shown above. In the case of a sequential search, "Seq Scan" will be displayed. Our goal here is to transform this "Seq Scan" into "Index Scan using #{PGroonga index name}" as shown below.

```sql
EXPLAIN ANALYZE SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
--                                                           QUERY PLAN                                                          
-- ------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using pgrn_content_index on memos  (cost=0.00..4.02 rows=1 width=64) (actual time=0.778..0.782 rows=2 loops=1)
--    Index Cond: (content &@~ 'PostgreSQL'::text)
--  Planning Time: 0.835 ms
--  Execution Time: 1.002 ms
-- (4 rows)
```
</details>

**Q: I think I set up the index, but I still see sequential scans.**

**A:** Ensure that a PGroonga index is actually set on your table. You may have simply forgotten to create one, especially in a database with many tables and indexes. Use the command `\d tablename` in `psql` to list the indexes on a specific table and verify that the PGroonga index appears. If the index is missing, you'll need to create it using `CREATE INDEX` with the correct specifications.

**Q: Could it be an issue with the data type I'm using?**

**A:** Yes, using the wrong data type could mean the index isn't used. Each operator in PGroonga supports specific data types. For instance, the `&>` operator supports `varchar[]`, but not `text[]`. Ensure that your column type matches the operator's supported types as listed in PGroonga’s documentation. You might need to CAST your column to a supported type or alter your index accordingly.

**Q: How do I know which index I should use for an operator class I want to use?**

**A:** Different operators often require specific operator classes. For example, when searching with `&^`, and your column is of a text type, you need to specify `pgroonga_text_term_search_ops_v2` as the operator class when creating the index. You can consult the [PGroonga documentation](https://pgroonga.github.io/reference/) to confirm the required operator class for your use case.

**Q: My queries involve multiple columns; could that affect index usage?**

**A:** Yes, when using `ARRAY[]` to search multiple columns, the order of columns must match between your index definition and the search query. If your index is created with `ARRAY[title, content]`, but your query uses `ARRAY[content, title]`, the index will not be utilized. Ensure that the order is consistent to enable index scanning.

**Q: I've tried these steps, but the issue persists. Is it the PGroonga extension itself?**

**A:** If none of these checks resolve the issue, it could be a deeper problem with PGroonga. Consider reporting your specific case to [PGroonga Issues](https://github.com/pgroonga/pgroonga/issues) or engage in [Discussions](https://github.com/pgroonga/pgroonga/discussions) for community assistance. They can provide insights or updates that might be affecting your setup.
