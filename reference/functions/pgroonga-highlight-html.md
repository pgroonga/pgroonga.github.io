---
title: pgroonga.highlight_html function
upper_level: ../
---

# `pgroonga.highlight_html` function

Since 1.0.7.

## Summary

`pgroonga.highlight_html` function surrounds the specified keywords in the specified text by `<span class="keyword">` and `</span>`. HTML special characters such as `&` in the specified text are escaped.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.highlight_html(target, ARRAY[keyword1, keyword2, ...])
```

`target` is a text to be highlighted. It's `text` type.

`keyword1`, `keyword2`, `...` are keywords to be highlighted. They're an array of `text` type. You must specify one or more keywords.

`pgroonga.highlight_html` markups the keywords in `target`. It's type is `text` type.

The keywords are surrounded with `<span class="keyword">` and `</span>`. `<`, `>`, `&` and `"` in `target` is HTML escaped.

## Usage

You need to specify at least one keyword:

```sql
SELECT pgroonga.highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['PostgreSQL']);
--                           highlight_html                          
-- ------------------------------------------------------------------
--  PGroonga is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

You can specify multiple keywords:

```sql
SELECT pgroonga.highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['Groonga', 'PostgreSQL']);
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

You can extract keywords from query by [`pgroonga.query_extract_keywords` function](pgroonga-query-extract-keywords.html):

```sql
SELECT pgroonga.highlight_html('PGroonga is a PostgreSQL extension.',
                               pgroonga.query_extract_keywords('Groonga PostgreSQL -extension'));
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

HTML special characters are escaped automatically:

```sql
SELECT pgroonga.highlight_html('<p>PGroonga is Groonga & PostgreSQL.</p>',
                               ARRAY['PostgreSQL']);
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  &lt;p&gt;PGroonga is Groonga &amp; <span class="keyword">PostgreSQL</span>.&lt;/p&gt;
-- (1 row)
```

Characters are normalized:

```sql
SELECT pgroonga.highlight_html('PGroonga + pglogical = replicatable!',
                               ARRAY['Pg']);
                                         highlight_html                                         
------------------------------------------------------------------------------------------------
 <span class="keyword">PG</span>roonga + <span class="keyword">pg</span>logical = replicatable!
(1 row)
```

Multibyte characters are also supported:

```sql
SELECT pgroonga.highlight_html('10㌖先にある100ｷﾛグラムの米',
                               ARRAY['キロ']);
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  10<span class="keyword">㌖</span>先にある100<span class="keyword">ｷﾛ</span>グラムの米
-- (1 row)
```

## See also

  * [`pgroonga.query_extract_keywords` function](pgroonga-query-extract-keywords.html)
