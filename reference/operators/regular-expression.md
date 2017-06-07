---
title: "@~ operator"
upper_level: ../
---

# `@~` operator

## Summary

This operator is deprecated since 1.2.1. Use [`&~` operator][regular-expression-v2] instead.

`@~` operator performs regular expression search.

PostgreSQL provides the following built-in regular expression operators:

  * [`SIMILAR TO`][postgresql-similar-to]

  * [POSIX Regular Expression][postgresql-regexp]

`SIMILAR TO` is based on SQL standard. "POSIX Regular Expression" is based on POSIX. They use different regular expression syntax.

PGroonga's `@~` operator uses another regular expression syntax. `@~` uses syntax that is used in [Ruby][ruby]. Because PGroonga uses the same regular expression engine that is used in Ruby. It's [Onigmo][onigmo]. See [Onigmo document][onigmo-document] for full syntax definition.

PGroonga's `@~` operator normalizes target text before matching. It's similar to `~*` operator in "POSIX Regular Expression". It performs case insensitive match.

Normalization is different from case insensitive. Normally, normalization is more powerful.

Example1: All of "`A`", "`a`", "`Ａ`" (U+FF21 FULLWIDTH LATIN CAPITAL LETTER A), "`ａ`" (U+FF41 FULLWIDTH LATIN SMALL LETTER A) are normalized to "`a`".

Example2: Both of full-width Katakana and half-width Katakana are normalized to full-width Katakana. For example, both of "`ア`" (U+30A2 KATAKANA LETTER A) and "`ｱ`" (U+FF71 HALFWIDTH KATAKANA LETTER A) are normalized to "`ア`" (U+30A2 KATAKANA LETTER A).

Note that `@~` operator doesn't normalize regular expression pattern. It only normalizes target text. It means that you must use normalized characters in regular expression pattern.

For example, you must not use "`Groonga`" as pattern. You must use "`groonga`" as pattern. Because "`G`" in target text is normalized to "`g`". "`Groonga`" is never appeared in target text.

Some simple regular expression patterns can be searched by index in Groonga. If index is used, the search is very fast. See [Groonga's regular expression document](http://groonga.org/docs/reference/regular_expression.html#regular-expression-index) for index searchable patterns.

If a regular expression pattern can't be searchable by index, it's searched by sequential scan in Groonga.

Note that Groonga may search with regular expression pattern by sequential scan even when `EXPLAIN` reports PostgreSQL uses PGroonga index.

## Syntax

```sql
column @~ regular_expression
```

`column` is a column to be searched. It's `text` type or `varchar` type.

`regular_expression` is a regular expression to be used as pattern. It's `text` type for `text` type `column`. It's `varchar` type for `varchar` type column.

If `column` value is matched against `regular_expression` pattern, the expression returns `true`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_regexp_ops`: For `text`

  * `pgroonga.varchar_regexp_ops`: For `varchar`

  * `pgroonga.text_regexp_ops_v2`: For `text`

  * `pgroonga.varchar_regexp_ops_v2`: For `varchar`

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

Here are data for examples:

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

You can perform regular expression search by `@~` operator:

```sql
SELECT * FROM memos WHERE content @~ '\Apostgresql';
--  id |                        content                         
-- ----+--------------------------------------------------------
--   1 | PostgreSQL is a relational database management system.
-- (1 row)
```

"`\A`" in "`\Apostgresql`" is a special notation in Ruby regular expression syntax. It means that the beginning of text. The pattern means that "`postgresql`" must be appeared in the beginning of text.

Why is "`PostgreSQL is a ...`" record matched? Remember that `@~` operator normalizes target text before matching. It means that "`PostgreSQL is a ...`" text is normalized to "`postgresql is a ...`" text before matching. The normalized text is started with "`postgresql`". So "`\Apostgresql`" regular expression matches to the record.

"`PGroonga is a PostgreSQL ...`" record isn't matched. It includes "`postgresql`" in normalized text but "`postgresql`" isn't appeared at the beginning of text. So it's not matched.

## See also

  * [`&~` operator][regular-expression-v2]

  * [Onigmo's regular expression syntax document][onigmo-document]

  * [Groonga's regular expression support document][groonga-regular-expression]

[regular-expression-v2]:regular-expression-v2.html

[postgresql-similar-to]:{{ site.postgresql_doc_base_url.en }}/functions-matching.html#FUNCTIONS-SIMILARTO-REGEXP

[postgresql-regexp]:{{ site.postgresql_doc_base_url.en }}/functions-matching.html#FUNCTIONS-POSIX-REGEXP

[ruby]:https://www.ruby-lang.org/

[onigmo]:https://github.com/k-takata/Onigmo

[onigmo-document]:https://github.com/k-takata/Onigmo/blob/master/doc/RE

[groonga-regular-expression]:http://groonga.org/docs/reference/regular_expression.html#regular-expression-index

