---
title: pgroonga_normalize function
upper_level: ../
---

# `pgroonga_normalize` function

Since 2.0.3.

## Summary

`pgroonga_normalize` function converts a text into a normalized form using [Groonga's normalizer modules](http://groonga.org/docs/reference/normalizers.html).
This function lets you use the same preprocessing mechanism that Groonga uses before tokenizing.

## Syntax

Here is the syntax of this function:

```text
text pgroonga_normalize(string)
```

`string` is a `text` type value to be normalized. By default, it uses the built-in [NormalizerAuto](http://groonga.org/docs/reference/normalizers.html#normalizerauto) module for normalization.

You can also use a different normalizer module by passing the second argument:

```text
text pgroonga_normalize(string, normalizerName)
```

`normalizerName` is a `text` type value which specifies the normalizer module you want to use.

## Usage

Here is an example usage of `pgroonga_normalize` function:

```sql
SELECT pgroonga_normalize('aBcDe 123');
--  pgroonga_normalize 
-- --------------------
--  abcde 123
-- (1 row)
```

You can also use non-default normalizers (if installed on the system):

```sql
SELECT pgroonga_normalize('Àá', 'NormalizerMySQLGeneralCI');
--  pgroonga_normalize 
-- --------------------
--  AA
-- (1 row)
```

## See also

 * [Groonga document on normalizers](http://groonga.org/docs/reference/normalizers.html)
