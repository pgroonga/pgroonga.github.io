---
title: pgroonga.score function
layout: en
---

# `pgroonga.score` function

You can use `pgroonga.score` function to get precision as a number. If a record is more precision against searched query, the record has more higher number.

You need to add primary key column into `pgroonga` index to use `pgroonga.score` function. If you don't add primary key column into `pgroonga` index, `pgroonga.score` function always returns `0`.

`pgroonga.score` function always returns `0` when full text search isn't performed by index. In other words, `pgroonga.score` function always returns `0` when full text search is performed by sequential scan.

If `pgroonga.score` function returns `0` unexpectedly, confirm the followings:

  * Whether the column that is specified as primary key is included in index targets of the PGroonga index or not
  * Whether the full text search is performed by index or not

Score is "how many keywords are included" (TF, Term Frequency) for now. Groonga supports customizing how to score. But PGroonga doesn't support yet it for now.

See also [examples in tutorial](../../tutorial/#score).
