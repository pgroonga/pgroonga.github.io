---
title: pgroonga_score function
upper_level: ../
---

# `pgroonga_score` function

## Summary

`pgroonga_score` function returns precision as a number. If a record is more precision against searched query, the record has more higher number.

## Syntax

You can use `pgroonga_score` function to get precision as a number. If a record is more precision against searched query, the record has more higher number.

```text
double precision pgroonga_score(record)
```

`record` is a table name.

Assume that you have the following schema:

```sql
CREATE TABLE score_memos (
  id integer PRIMARY KEY,
  content text
);

CREATE INDEX pgroonga_score_memos_content_index
          ON score_memos
       USING pgroonga (id, content);
```

`record` must be `score_memos`:

```sql
SELECT *, pgroonga_score(score_memos)
  FROM score_memos
 WHERE content %% 'PGroonga';
```

`pgroonga_score` function return precision as `double precision` type value.

## Usage

You need to add primary key column into `pgroonga` index to use `pgroonga_score` function. If you don't add primary key column into `pgroonga` index, `pgroonga_score` function always returns `0.0`.

`pgroonga_score` function always returns `0.0` when full text search isn't performed by index. In other words, `pgroonga_score` function always returns `0.0` when full text search is performed by sequential scan.

If `pgroonga_score` function returns `0.0` unexpectedly, confirm the followings:

  * Whether the column that is specified as primary key is included in index targets of the PGroonga index or not
  * Whether the full text search is performed by index or not

Score is "how many keywords are included" (TF, Term Frequency) for now. Groonga supports customizing how to score. But PGroonga doesn't support yet it for now.

See [examples in tutorial](../../tutorial/#score).

## See also

  * [Examples in tutorial](../../tutorial/#score)
