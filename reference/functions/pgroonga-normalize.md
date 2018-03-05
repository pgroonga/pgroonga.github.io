---
title: pgroonga_normalize function
upper_level: ../
---

# `pgroonga_normalize` function

Since 2.0.3.

## Summary

`pgroonga_normalize` function converts a text into a normalized form using [Groonga's normalizer modules][groonga-normalizers].
This function lets you use the same preprocessing mechanism that Groonga uses before tokenizing.

## Syntax

Here is the syntax of this function:

```text
text pgroonga_normalize(target)
```

`target` is a `text` type value to be normalized. By default, it uses the built-in [NormalizerAuto][groonga-normalizer-auto] module for normalization.

Here is another syntax of this function:

```text
text pgroonga_normalize(target, normalizerName)
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

 * [Groonga document for normalizers][groonga-normalizers]

[groonga-normalizers]:http://groonga.org/docs/reference/normalizers.html

[groonga-normalizer-auto]:http://groonga.org/docs/reference/normalizers.html#normalizer-auto
