---
title: pgroonga_normalize function
upper_level: ../
---

# `pgroonga_normalize` function

Since 2.0.3.

## Summary

`pgroonga_normalize` function converts a text into a normalized form using [Groonga's normalizer modules][groonga-normalizers].

## Syntax

Here is the syntax of this function:

```text
text pgroonga_normalize(target)
```

`target` is a `text` type value to be normalized. By default, it uses the built-in [`NormalizerAuto`][groonga-normalizer-auto] normalizer.

Here is another syntax of this function:

```text
text pgroonga_normalize(target, normalizer)
```

`normalizer` is a `text` type value which specifies the normalizer module you want to use.

## Usage

You can normalize a `text` type value:

```sql
SELECT pgroonga_normalize('aBcDe 123');
--  pgroonga_normalize 
-- --------------------
--  abcde 123
-- (1 row)
```

You can specify the normalizer:

```sql
SELECT pgroonga_command('plugin_register normalizers/mysql');
SELECT pgroonga_normalize('aBcDe 123', 'NormalizerMySQLGeneralCI');
--  pgroonga_normalize 
-- --------------------
--  ABCDE 123
-- (1 row)
```

`plugin_register normalizers/mysql` is needed to use [groonga-normalizer-mysql][groonga-normalizer-mysql]. It provides some MySQL compatible normalizers.

You can also specify normalizer options:

```sql
SELECT pgroonga_normalize('あア', 'NormalizerNFKC130("unify_kana", true)');
--  pgroonga_normalize 
-- --------------------
--  ああ
-- (1 row)
```

You may also specify multiple normalizers. Here is an useless example:

```sql
SELECT pgroonga_normalize('あー-ア', 
  '
    NormalizerNFKC130("unify_kana", true),
    NormalizerNFKC130("unify_hyphen_and_prolonged_sound_mark", true)
  '
);
--  pgroonga_normalize 
-- --------------------
--  あ--あ
-- (1 row)
```

## See also

  * [Groonga document for normalizers][groonga-normalizers]

[groonga-normalizers]:http://groonga.org/docs/reference/normalizers.html

[groonga-normalizer-auto]:http://groonga.org/docs/reference/normalizers.html#normalizer-auto

[groonga-normalizer-mysql]:https://github.com/groonga/groonga-normalizer-mysql
