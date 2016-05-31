---
title: pgroonga.snippet_html function
---

# `pgroonga.snippet_html` function

## Summary

`pgroonga.snippet_html` function returns texts around keywords from target text. It's also known as [KWIC](https://en.wikipedia.org/wiki/Key_Word_in_Context) (keyword in context). You can see it in search result on Web search engine.

## Syntax

Here is the syntax of this function:

```text
text[] pgroonga.snippet_html(target, ARRAY[keyword1, keyword2, ...])
```

`target` is a `text` type value. `pgroonga.snippet_html` extracts keywords with around texts from `target`.

`keyword1`, `keyword2`, `...` are an array of `text` type. The keywords to be extracted from `target`. You must specify one or more keywords.

`pgroonga.snippet_html` returns an array of `text` type.

Element in the returned array is a text around keyword.

The keywords are surrounded with `<span class="keyword">` and `</span>`. `<`, `>`, `&` and `"` in `target` is HTML escaped.

The maximum size of part of `target` in each element is 200 bytes. Its unit is byte not the number of characters. Each element may be lager than 200 bytes because each element includes `<span class="keyword">` and `</span>` and may have HTML escaped values. If `<` is HTML escaped to `&lt;`, the byte size is increased to 4 from 1.

## Usage

See [examples in tutorial](../../tutorial/#snippet).

## See also

  * [Examples in tutorial](../../tutorial/#snippet)

  * [`pgroonga.query_extract_keywords` function](pgroonga-query-extract-keywords.html)
