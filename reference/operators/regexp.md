---
title: "@~ operator"
layout: en
---

# `@~` operator

## Summary

`@~` operator performs regular expression search.

PostgreSQL provides the following built-in regular expression operators:

  * [`SIMILAR TO`](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/functions-matching.html#FUNCTIONS-SIMILARTO-REGEXP)

  * [POSIX Regular Expression](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/functions-matching.html#FUNCTIONS-POSIX-REGEXP)

`SIMILAR TO` is based on SQL standard. "POSIX Regular Expression" is based on POSIX. They use different regular expression syntax.

PGroonga's `@~` operator uses another regular expression syntax. `@~` uses syntax that is used in [Ruby](https://www.ruby-lang.org/). Because PGroonga uses the same regular expression engine that is used in Ruby. It's [Onigmo](https://github.com/k-takata/Onigmo). See [Onigmo document](https://github.com/k-takata/Onigmo/blob/master/doc/RE) for full syntax definition.

PGroonga's `@~` operator normalizes target text before matching. It's similar to `~*` operator in "POSIX Regular Expression". It performs case insensitive match.

Normalization is different from case insensitive. Normally, normalization is more powerful.

Example1: All of "A", "a", "Ａ" (U+FF21 FULLWIDTH LATIN CAPITAL LETTER A), "ａ" (U+FF41 FULLWIDTH LATIN SMALL LETTER A) are normalized to "a".

Example2: Both of full-width Hiragana and half-width Katakana are normalized to full-width Katakana. For example, both of "ア" (U+30A2 KATAKANA LETTER A) and "ｱ" (U+FF71 HALFWIDTH KATAKANA LETTER A) are normalized to "ア" (U+30A2 KATAKANA LETTER A.

Note that `@~` operator doesn't normalize regular expression pattern. It only normalizes target text. It means that you must use normalized characters in regular expression pattern.

For example, you must not use `Groonga` as pattern. You must use `groonga` as pattern. Because "G" is normalized to "g".

## Syntax

```sql
column @~ regular_expression
```

`column` is a column to be searched.

`regular_expression` is a regular expression to be used as pattern.

Types of `column` and `regular_expression` must be the same. Here are available types:

  * `text`

  * `varchar`

## Usage

Here are sample schema for examples:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga.text_regexp_ops);
```

You must specify operator class to perform regular expression search by index. Here are available operator classes:

  * `pgroonga.text_regexp_ops`: It's the operator class for `text` type column.

  * `pgroonga.varchar_regexp_ops`: It's the operator class for `varchar` type column.

In this example, we use `pgroonga.text_regexp_ops`. Because `content` column is a `text` type column.

Here are data for examples:

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

You can perform regular expression search by `@~` operator:

```sql
SELECT * FROM memos WHERE content @~ '\Agroonga';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (1 row)
```

"`\A`" in "`\Agroonga`" is a special notation in Ruby regular expression syntax. It means that the beginning of text. The pattern means that "`groonga`" must be appeared in the beginning of text.

TODO
