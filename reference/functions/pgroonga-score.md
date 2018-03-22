---
title: pgroonga_score function
upper_level: ../
---

# `pgroonga_score` function

## Summary

`pgroonga_score` function returns precision as a number. If a record is more precision against searched query, the record has more higher number.

## Syntax

You can use `pgroonga_score` function to get precision as a number. If a record is more precision against searched query, the record has more higher number.

There are two signatures:

```text
double precision pgroonga_score(tableoid, ctid)
double precision pgroonga_score(record)
```

The former is available since 2.0.4. It's faster than the latter.

The latter is deprecated since 2.0.4.

Here is the description of the former signature.

```text
double precision pgroonga_score(tableoid, ctid)
```

`tableoid` is a table OID. You can use `tableoid` [system column][postgresql-system-columns] for this parameter.

`ctid` is a ID of the row. You can use `ctid` [system column][postgresql-system-columns] for this parameter.

With this signature, you don't need to add primary key to PGroonga index.

Assume that you have the following schema:

```sql
CREATE TABLE score_memos (
  content text
);

CREATE INDEX pgroonga_score_memos_content_index
          ON score_memos
       USING pgroonga (content);
```

You can use `pgroonga_score` of this signature like the following:

```sql
SELECT *, pgroonga_score(tableoid, ctid)
  FROM score_memos
 WHERE content &@~ 'PGroonga';
```

`pgroonga_score` function returns precision as `double precision` type value.

Here is the description of the latter signature.

```text
double precision pgroonga_score(record)
```

`record` is a table name.

You must put primary key to PGroonga index to use `pgroonga_score` of this signature.

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
 WHERE content&@~ 'PGroonga';
```

`pgroonga_score` function returns precision as `double precision` type value.

## Usage

If you want to use `pgroonga_score(record)` version, you need to add primary key column into PGroonga index. If you don't add primary key column into PGroonga index, `pgroonga_score` function always returns `0.0`.

If you want to use `pgroonga_score(tableoid, ctid)` version, you don't need to add primary key column into PGroonga index.

`pgroonga_score` function always returns `0.0` when full text search isn't performed by index. In other words, `pgroonga_score` function always returns `0.0` when full text search is performed by sequential scan.

If `pgroonga_score` function returns `0.0` unexpectedly, confirm the followings:

  * Whether the column that is specified as primary key is included in index targets of the PGroonga index or not
  * Whether the full text search is performed by index or not

Score is "how many keywords are included" (TF, Term Frequency) for now. Groonga supports customizing how to score. But PGroonga doesn't support yet it for now.

See [examples in tutorial][tutorial-score].

## See also

  * [Examples in tutorial][tutorial-score]

[postgresql-system-columns]:{{ site.postgresql_doc_base_url.en }}/ddl-system-columns.html

[tutorial-score]:../../tutorial/#score
