---
title: Troubleshooting
---
# Troubleshooting

Many PGroonga search issues stem from improper index setup. This troubleshooting guide addresses these problems.

The following sections use a Q&A format to explain these issues in detail.

## Q: I created a PGroonga index, but my searches are still slow.

A: When a search is slow, it often means PostgreSQL is using a sequential scan instead of the PGroonga index. To check this, run your query with `EXPLAIN ANALYZE`. 

If you see "Seq Scan" in the output, it indicates the system is not utilizing the index. The goal is to see "Index Scan using pgrn_content_index" or similar, indicating the index is being used.

Check the table configuration to confirm that PGroonga indexes are properly set.

<details markdown="block">

<summary markdown="span">To confirm whether a sequential search is being executed</summary>
  
We use a following table structure as an example.
  
To ensure the search is definitely sequential in this example, no indexes or primary keys have been set.

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

Now, let's confirm whether the query is using a sequential search.

As mentioned earlier, we'll use `EXPLAIN ANALYZE` to check.

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

The result is as shown above.

In the case of a sequential search, "Seq Scan" will be displayed.

Our goal here is to transform this "Seq Scan" into "Index Scan using #{PGroonga index name}" as shown below.

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

