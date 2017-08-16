---
title: pgroonga_match_positions_byte function
upper_level: ../
---

# `pgroonga_match_positions_byte` function

Since 1.0.7.

## Summary

`pgroonga_match_positions_byte` function returns positions of the specified keywords in the specified text. The unit of position is byte. If you want to highlight keywords for HTML output, [`pgroonga_snippet_html` function](pgroonga-snippet-html.html) or [`pgroonga_highlight_html` function](pgroonga-highlight-html.html) will be suitable. `pgroonga_match_positions_byte` function is for advanced use.

If you want in character version, see [`pgroonga_match_positions_character`](pgroonga-match-positions-character.html) instead.

## Syntax

Here is the syntax of this function:

```text
integer[2][] pgroonga_match_positions_byte(target, ARRAY[keyword1, keyword2, ...])
```

`target` is a text to be searched. It's `text` type.

`keyword1`, `keyword2`, `...` are keywords to be found. They're an array of `text` type. You must specify one or more keywords.

`pgroonga_match_positions_byte` returns an array of positions.

Position consists of offset and length. Offset is the start byte from the beginning. Length is the number of bytes of matched text. Length may be different size with the length of keyword. Because keyword and matched text are normalized.

## Usage

You need to specify at least one keyword:

{% raw %}
```sql
SELECT pgroonga_match_positions_byte('PGroonga is a PostgreSQL extension.',
                                     ARRAY['PostgreSQL']) AS match_positions_byte;
--  match_positions_byte 
-- ----------------------
--  {{14,10}}
-- (1 row)
```
{% endraw %}

You can specify multiple keywords:

{% raw %}
```sql
SELECT pgroonga_match_positions_byte('PGroonga is a PostgreSQL extension.',
                                     ARRAY['Groonga', 'PostgreSQL']) AS match_positions_byte;
--  match_positions_byte 
-- ----------------------
--  {{1,7},{14,10}}
-- (1 row)
```
{% endraw %}

You can extract keywords from query by [`pgroonga_query_extract_keywords` function](pgroonga-query-extract-keywords.html):

{% raw %}
```sql
SELECT pgroonga_match_positions_byte('PGroonga is a PostgreSQL extension.',
                                     pgroonga_query_extract_keywords('Groonga PostgreSQL -extension')) AS match_positions_byte;
--  match_positions_byte 
-- ----------------------
--  {{1,7},{14,10}}
-- (1 row)
```
{% endraw %}

Characters are normalized:

{% raw %}
```sql
SELECT pgroonga_match_positions_byte('PGroonga + pglogical = replicatable!',
                                     ARRAY['Pg']) AS match_positions_byte;
--  match_positions_byte 
-- ----------------------
--  {{0,2},{11,2}}
-- (1 row)
```
{% endraw %}

Multibyte characters are also supported:

{% raw %}
```sql
SELECT pgroonga_match_positions_byte('10㌖先にある100ｷﾛグラムの米',
                                     ARRAY['キロ']) AS match_positions_byte;
--  match_positions_byte 
-- ----------------------
--  {{2,3},{20,6}}
-- (1 row)
```
{% endraw %}

## See also

  * [`pgroonga_match_positions_character` function][match-positions-character]

  * [`pgroonga_snippet_html` function][query-snippet-html]

  * [`pgroonga_highlight_html` function][query-highlight-html]

  * [`pgroonga_query_extract_keywords` function][query-extract-keywords]

[match-positions-character]:pgroonga-match-positions-character.html
[query-snippet-html]:pgroonga-query-snippet-html.html
[query-highlight-html]:pgroonga-query-highlight-html.html
[query-extract-keywords]:pgroonga-query-extract-keywords.html

