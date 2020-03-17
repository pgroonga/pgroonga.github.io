---
title: Test
---

# Test

You should create a regression test when you implement a new feature or fix a bug.

## Summary

Regression tests exist under `sql/` directory. For example, `sql/full-text-search/text/single/match-v2/indexscan.sql` is a test for the following case:

  * Full text search

  * `text` type

  * [`&@`][match-v2] (v2 match operator)

  * Index scan

The expected outputs exist under `expected/` directory. Directory structure is the same as `sql/` but the expected outputs use `.out` extension such as `expected/full-text-search/text/single/match-v2/indexscan.out`.

## How to create a regression test

You create a new file under `sql/` and put test scenario in SQL into the file. Then, run the file like the following:

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh sql/.../XXX.sql
```

The newly created test is failed and `test/run-sql-test.sh` shows the output of the test scenario. If the output is correct, copy the output and paste it to `expected/.../XXX.out`.

You should confirm the test is passed by updating `expected/.../XXX.out`:

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh sql/.../XXX.sql
```

[match-v2]:../reference/operators/match-v2.html
