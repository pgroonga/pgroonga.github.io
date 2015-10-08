---
title: pgroonga.snippet function
layout: en
---

# `pgroonga.snippet` function

Here is `pgroonga.snippet_html` signature:

```text
pgroonga.snippet_html(target, ARRAY[keyword1, keyword2, ...])
```

`target` is a `text` type value. `pgroonga.snippet_html` extracts keywords with around texts from `target`.

`keyword1`, `keyword2`, `...` are an array of `text` type. The keywords to be extracted from `target`. You must specify one or more keywords.

`pgroonga.snippet_html` returns an array of `text` type.

Element in the returned array is a text around keyword. The keyword is surround with `<span class="keyword">` and `</span>`. `<`, `>`, `&` and `"` in `target` is HTML escaped.

The maximum size of part of `target` in each element is 200 bytes. It's unit is byte not the number of characters. Each element may be lager than 200 bytes because each element includes `<span class="keyword">` and `</span>` and may have HTML escaped values. If '<' is HTML escaped to `&lt;`, the byte size is increased to 4 from 1.

See also [examples in tutorial](../../tutorial/#snippet).
