---
title: pgroonga_highlight_html function
upper_level: ../
---

# `pgroonga_highlight_html` function

Since 1.0.7.

## Summary

`pgroonga_highlight_html` function surrounds the specified keywords in the specified text by `<span class="keyword">` and `</span>`. HTML special characters such as `&` in the specified text are escaped.

## Syntax

There are two signatures:

```text
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...])
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...], index_name)
```

The first signature is simpler than others. The first signature is enough for most cases.

The second signature is useful when you use custom normalizer.

The second signature is available since 2.0.7.

Here is the description of the first signature.

```text
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...])
```

`target` is a text to be highlighted. It's `text` type.

`keyword1`, `keyword2`, `...` are keywords to be highlighted. They're an array of `text` type. You must specify one or more keywords.

`pgroonga_highlight_html` markups the keywords in `target`. It's type is `text` type.

The keywords are surrounded with `<span class="keyword">` and `</span>`. `<`, `>`, `&` and `"` in `target` is HTML escaped.

Here is the description of the second signature.

```text
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...], index_name)
```

`target` is a text to be highlighted. It's `text` type.

`keyword1`, `keyword2`, `...` are keywords to be highlighted. They're an array of `text` type. You must specify one or more keywords.

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.

`index_name` can be `NULL`.

If you aren't using `NormalizerAuto` normalizer such as `NormalizerNFKC100`, it's better that you use `index_name`. This function uses `NormalizerAuto` normalizer by default. It may cause unexpected result.

If you specify `index_name`, the specified PGroonga index must have `TokenNgram` tokenizer with `"report_source_location"` option.

Here is an example:

```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenNgram("report_source_location", true)',
              normalizer='NormalizerNFKC100');
```

Now, you can use `pgroonga_content_index` as `index_name`:

```sql
SELECT pgroonga_highlight_html('one two three four five',
                               ARRAY['two three', 'five'],
                               'pgroonga_content_index');
--                               pgroonga_highlight_html                              
-- -----------------------------------------------------------------------------------
--  one<span class="keyword"> two three</span> four<span class="keyword"> five</span>
-- (1 row)
```

`pgroonga_highlight_html` markups the keywords in `target`. It's type is `text` type.

The keywords are surrounded with `<span class="keyword">` and `</span>`. `<`, `>`, `&` and `"` in `target` is HTML escaped.

It's available since 2.0.7.

## Usage

You need to specify at least one keyword:

```sql
SELECT pgroonga_highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['PostgreSQL']) AS highlight_html;
--                           highlight_html                          
-- ------------------------------------------------------------------
--  PGroonga is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

You can specify multiple keywords:

```sql
SELECT pgroonga_highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['Groonga', 'PostgreSQL']) AS highlight_html;
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

You can extract keywords from query by [`pgroonga_query_extract_keywords` function](pgroonga-query-extract-keywords.html):

```sql
SELECT pgroonga_highlight_html('PGroonga is a PostgreSQL extension.',
                               pgroonga_query_extract_keywords('Groonga PostgreSQL -extension')) AS highlight_html;
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

HTML special characters are escaped automatically:

```sql
SELECT pgroonga_highlight_html('<p>PGroonga is Groonga & PostgreSQL.</p>',
                               ARRAY['PostgreSQL']) AS highlight_html;
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  &lt;p&gt;PGroonga is Groonga &amp; <span class="keyword">PostgreSQL</span>.&lt;/p&gt;
-- (1 row)
```

Characters are normalized:

```sql
SELECT pgroonga_highlight_html('PGroonga + pglogical = replicatable!',
                               ARRAY['Pg']) AS highlight_html;
--                                     highlight_html                                         
-- ------------------------------------------------------------------------------------------------
--  <span class="keyword">PG</span>roonga + <span class="keyword">pg</span>logical = replicatable!
-- (1 row)
```

Multibyte characters are also supported:

```sql
SELECT pgroonga_highlight_html('10㌖先にある100ｷﾛグラムの米',
                               ARRAY['キロ']) AS highlight_html;
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  10<span class="keyword">㌖</span>先にある100<span class="keyword">ｷﾛ</span>グラムの米
-- (1 row)
```

Custom tokenizer and normalizer can be used by specifying a PGroonga index name:

```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenNgram("report_source_location", true)',
              normalizer='NormalizerNFKC100');

SELECT pgroonga_highlight_html('one two three four five',
                               ARRAY['two three', 'five'],
                               'pgroonga_content_index');
--                               pgroonga_highlight_html                              
-- -----------------------------------------------------------------------------------
--  one<span class="keyword"> two three</span> four<span class="keyword"> five</span>
-- (1 row)
```

## Practical Example: Keyword Search and Highlight

Here is an example of implementing keyword search feature with `pgroonga_highlight_html`.
Imagine you are building a blog, and for simplicity, this blog’s post model only has 'id', 'title' and 'body' fields.

```sql
CREATE TABLE posts (
  id SERIAL NOT NULL,
  title varchar(255),
  body text
);

-- Create PGroonga Index 
CREATE INDEX pgroonga_posts_index
          ON posts
       USING pgroonga (title, body);

-- Insert some sample data
INSERT INTO posts VALUES (1, 'Quote of the day one', 'Design is not just what it looks like and feels like. Design is how it works.');
INSERT INTO posts VALUES (2, 'Quote of the day two', 'If everyone is busy making everything, how can any one perfect anything?');
INSERT INTO posts VALUES (3, 'Quote of the day three', 'There are a thousand no''s, for every yes.');
```


Then you may use `pgroonga_highlight_html` function to search through your blog posts, and get the result with keywords highlighted like this:

```sql
SELECT
   pgroonga_highlight_html(title, pgroonga_query_extract_keywords('thousand')) AS highlighted_title,
   pgroonga_highlight_html(body, pgroonga_query_extract_keywords('thousand')) AS highlighted_body
   from posts where title &@~ 'thousand' or body &@~ 'thousand';

--    highlighted_title    |                            highlighted_body                            
-- ------------------------+------------------------------------------------------------------------
--  Quote of the day three | There are a <span class="keyword">thousand</span> no's, for every yes.
--  (1 row)

```

If you have a lot of data to search through and return the result with pagination, it is not wise to use `pgroonga_highlight_html()` on that query. Because `pgroonga_highlight_html()` only works in sequentially, the more number of records for processing in `pgroonga_highlight_html()`  you have, slower it gets in performance.

To avoid this problem, in the following example, we reduce the number of records for processing in `pgroonga_highlight_html()` by using `pgroonga_highlight_html()`  on the result of your keyword search instead.

```sql
-- Good Performance
SELECT
   pgroonga_highlight_html(title, pgroonga_query_extract_keywords('Search Words')) AS highlighted_title,
   pgroonga_highlight_html(body, pgroonga_query_extract_keywords('Search Words')) AS highlighted_body
   from posts where id IN 
   (SELECT id FROM posts where title &@~ 'Search Words' or body &@~ 'Search Words' LIMIT 10 OFFSET 100);

-- Do not do this. You may experience some performance issue.
SELECT
   pgroonga_highlight_html(title, pgroonga_query_extract_keywords('Search Words')) AS highlighted_title,
   pgroonga_highlight_html(body, pgroonga_query_extract_keywords('Search Words')) AS highlighted_body
   from posts where title &@~ 'Search Words' or body &@~ 'Search Words' LIMIT 10 OFFSET 100;
```


## See also

  * [`pgroonga_query_extract_keywords` function][query-extract-keywords]

[query-extract-keywords]:pgroonga-query-extract-keywords.html
