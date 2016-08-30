---
title: pgroonga.match_positions_character function
---

# `pgroonga.match_positions_character` function

Since 1.1.1.

## Summary

`pgroonga.match_positions_character` function returns positions of the specified keywords in the specified text. The unit of position is character. If you want to highlight keywords for HTML output, [`pgroonga.snippet_html` function](pgroonga-snippet-html.html) or [`pgroonga.highlight_html` function](pgroonga-highlight-html.html) will be suitable. `pgroonga.match_positions_character` function is for advanced use.

If you want in byte version, see [`pgroonga.match_positions_byte`](pgroonga-match-positions-byte.html) instead.

## Syntax

Here is the syntax of this function:

```text
integer[2][] pgroonga.match_positions_character(target, ARRAY[keyword1, keyword2, ...])
```

`target` is a text to be searched. It's `text` type.

`keyword1`, `keyword2`, `...` are keywords to be found. They're an array of `text` type. You must specify one or more keywords.

`pgroonga.match_positions_character` returns an array of positions.

Position consists of offset and length. Offset is the start character from the beginning. Length is the number of characters of matched text. Length may be different size with the length of keyword. Because keyword and matched text are normalized.

## Usage

You need to specify at least one keyword:

{% raw %}
```sql
SELECT pgroonga.match_positions_character('PGroonga is a PostgreSQL extension.',
                                          ARRAY['PostgreSQL']);
--  match_positions_character 
-- ---------------------------
--  {{14,10}}
-- (1 row)
```
{% endraw %}

You can specify multiple keywords:

{% raw %}
```sql
SELECT pgroonga.match_positions_character('PGroonga is a PostgreSQL extension.',
                                          ARRAY['Groonga', 'PostgreSQL']);
--  match_positions_character 
-- ---------------------------
--  {{1,7},{14,10}}
-- (1 row)
```
{% endraw %}

You can extract keywords from query by [`pgroonga.query_extract_keywords` function](pgroonga-query-extract-keywords.html):

{% raw %}
```sql
SELECT pgroonga.match_positions_character('PGroonga is a PostgreSQL extension.',
                                          pgroonga.query_extract_keywords('Groonga PostgreSQL -extension'));
--  match_positions_character 
-- ---------------------------
--  {{1,7},{14,10}}
-- (1 row)
```
{% endraw %}

Characters are normalized:

{% raw %}
```sql
SELECT pgroonga.match_positions_character('PGroonga + pglogical = replicatable!',
                                          ARRAY['Pg']);
--  match_positions_character 
-- ---------------------------
--  {{0,2},{11,2}}
-- (1 row)
```
{% endraw %}

Multibyte characters are also supported:

{% raw %}
```sql
SELECT pgroonga.match_positions_character('10㌖先にある100ｷﾛグラムの米',
                                     ARRAY['キロ']);
--  match_positions_character 
-- ---------------------------
--  {{2,1},{10,2}}
-- (1 row)
```
{% endraw %}

## See also

  * [`pgroonga.match_positions_byte` function](pgroonga-match-positions-byte.html)

  * [`pgroonga.snippet_html` function](pgroonga-query-snippet-html.html)

  * [`pgroonga.highlight_html` function](pgroonga-query-highlight-html.html)

  * [`pgroonga.query_extract_keywords` function](pgroonga-query-extract-keywords.html)
