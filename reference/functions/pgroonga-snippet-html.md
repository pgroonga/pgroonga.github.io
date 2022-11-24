---
title: pgroonga_snippet_html function
upper_level: ../
---

# `pgroonga_snippet_html` function

## Summary

`pgroonga_snippet_html` function returns texts around keywords from target text. It's also known as [KWIC](https://en.wikipedia.org/wiki/Key_Word_in_Context) (keyword in context). You can see it in search result on Web search engine.

## Syntax

There are two use.

```text
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...])
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...], width)
```

The second use is useful when we customize a length of snippet.

The second use is available since 2.4.2.

Here is the description of the first use.

```text
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...])
```

`target` is a `text` type value. `pgroonga_snippet_html` extracts keywords with around texts from `target`.

`keyword1`, `keyword2`, `...` are an array of `text` type. The keywords to be extracted from `target`. You must specify one or more keywords.

Here is the description of the second use.

```text
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...], width)
```

`target` is a `text` type value. `pgroonga_snippet_html` extracts keywords with around texts from `target`.

`keyword1`, `keyword2`, `...` are an array of `text` type. The keywords to be extracted from `target`. You must specify one or more keywords.

`width` is a `integer` type value. This argument is an optional argument. The default value of `width` is 200.

We can dynamically specify a snippet length with this argument.

`pgroonga_snippet_html` returns an array of `text` type. However if we specify a value less than a length of keyword to `width`, no records are output.

Element in the returned array is a text around keyword.

The keywords are surrounded with `<span class="keyword">` and `</span>`. `<`, `>`, `&` and `"` in `target` is HTML escaped.

The maximum size of part of `target` in each element is 200 bytes. Its unit is byte not the number of characters. Each element may be lager than 200 bytes because each element includes `<span class="keyword">` and `</span>` and may have HTML escaped values. If `<` is HTML escaped to `&lt;`, the byte size is increased to 4 from 1.

## Usage

For example, if we want to adjust a length of snippet, we use the `width` argument as below.

```sql
SELECT pgroonga_snippet_html(
  'Groonga is a fast and accurate full text search engine based on ' ||
  'inverted index. One of the characteristics of Groonga is that a ' ||
  'newly registered document instantly appears in search results. ' ||
  'Also, Groonga allows updates without read locks. These characteristics ' ||
  'result in superior performance on real-time applications.' ||
  E'\n' ||
  E'\n' ||
  'Groonga is also a column-oriented database management system (DBMS). ' ||
  'Compared with well-known row-oriented systems, such as MySQL and ' ||
  'PostgreSQL, column-oriented systems are more suited for aggregate ' ||
  'queries. Due to this advantage, Groonga can cover weakness of ' ||
  'row-oriented systems.',
  ARRAY['Groonga'],
  50);

                                                                                                                    pgroonga_snippet_html                                                                                                                     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 {"<span class=\"keyword\">Groonga</span> is a fast and accurate full text search en","he characteristics of <span class=\"keyword\">Groonga</span> is that a newly regi","search results. Also, <span class=\"keyword\">Groonga</span> allows updates witho"}
(1 row)
```

Please also refer to [examples in tutorial](../../tutorial/#snippet).

## See also

  * [Examples in tutorial](../../tutorial/#snippet)

  * [`pgroonga_query_extract_keywords` function][query-extract-keywords]

[query-extract-keywords]:pgroonga-query-extract-keywords.html
