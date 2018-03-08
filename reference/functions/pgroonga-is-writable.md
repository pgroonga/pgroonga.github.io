---
title: pgroonga_is_writable function
upper_level: ../
---

# `pgroonga_is_writable` function

## Summary

`pgroonga_is_writable` function returns whether you can change PGroonga data or not.

## Syntax

Here is the syntax of this function:

```text
bool pgroonga_is_writable()
```

It returns whether you can change PGroonga data or not.

## Usage

Here is an example:

```sql
SELECT pgroonga_is_writable();
--  pgroonga_is_writable 
-- ----------------------
--  t
-- (1 row)
```

## See also

  * [`pgroonga_set_writable` function][set-writable]

[is-writable]:pgroonga-is-writable.html
