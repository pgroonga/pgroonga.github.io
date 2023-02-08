---
title: pgroonga_highlight_html関数
upper_level: ../
---

# `pgroonga_highlight_html`関数

1.0.7で追加。

## 概要

`pgroonga_highlight_html`関数は指定したテキスト中にある指定したキーワードを`<span class="keyword">`と`</span>`で囲みます。指定したテキスト中にある`&`などのHTMLの特別な文字はエスケープされます。

## 構文

使い方は2つあります。

```text
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...])
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...], index_name)
text[] pgroonga_highlight_html(ARRAY[target1, target2, ...],
                               ARRAY[keyword1, keyword2, ...])
text[] pgroonga_highlight_html(ARRAY[target1, target2, ...],
                               ARRAY[keyword1, keyword2, ...], index_name)
```

1つ目の使い方は他の使い方よりもシンプルです。多くの場合は1つ目の使い方で十分です。

2つ目の使い方はノーマライザーを変更しているときに便利です。

2つ目の使い方は2.0.7から使えます。

3つ目と4つ目の使い方は1つ目と2つ目の使い方の`text[]`バージョンです。

3つ目と4つ目の使い方は2.4.3から使えます。

以下は1つ目の使い方の説明です。

```text
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...])
```

`target`はハイライト対象のテキストです。型は`text`です。

キーワードは`<span class="keyword">`と`</span>`で囲まれています。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

`pgroonga_highlight_html`は`target`中のキーワードをマークアップします。型は`text`です。

キーワードは`<span class="keyword">`と`</span>`で囲まれます。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

以下は2つ目の使い方の説明です。

```text
text pgroonga_highlight_html(target, ARRAY[keyword1, keyword2, ...], index_name)
```

`target`はハイライト対象のテキストです。型は`text`です。

キーワードは`<span class="keyword">`と`</span>`で囲まれています。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

`index_name`には`NULL`を指定できます。

`NormalizerNFKC100`のように`NormalizerAuto`以外のノーマライザーを使っている場合は、`index_name`を使うとよいです。この関数はデフォルトで`NormalizerAuto`ノーマライザーを使います。これにより意図しない結果になることがあります。

`index_name`を指定した場合は、指定したPGroongaのインデックスには`"report_source_location"`オプションを指定した`TokenNgram`トークナイザーを指定しないといけません。

例です。

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

これで`index_name`に`pgroonga_content_index`を指定できます。

```sql
SELECT pgroonga_highlight_html('one two three four five',
                               ARRAY['two three', 'five'],
                               'pgroonga_content_index');
--                               pgroonga_highlight_html                              
-- -----------------------------------------------------------------------------------
--  one<span class="keyword"> two three</span> four<span class="keyword"> five</span>
-- (1 row)
```

`pgroonga_highlight_html`は`target`中のキーワードをマークアップします。型は`text`です。

キーワードは`<span class="keyword">`と`</span>`で囲まれます。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

2.0.7から使えます。

以下は3つ目の使い方の説明です。

```text
text[] pgroonga_highlight_html(ARRAY[target1, target2, ...],
                               ARRAY[keyword1, keyword2, ...])
```

`target1`、`target2`、`...`はハイライト対象のテキストです。型は`text`の配列です。

キーワードは`<span class="keyword">`と`</span>`で囲まれています。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

`pgroonga_highlight_html`は各`target`中のキーワードをマークアップします。`pgroonga_highlight_html`は`text`型の配列を返します。もし、ある`target`が`NULL`の場合は返ってくる配列の中の対応する要素も`NULL`になります。

キーワードは`<span class="keyword">`と`</span>`で囲まれます。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

```sql
SELECT pgroonga_highlight_html(ARRAY['one two three', NULL, 'five', 'six three'],
                               ARRAY['two three', 'six']);
--                                         pgroonga_highlight_html                                        
-- -------------------------------------------------------------------------------------------------------
--  {"one<span class=\"keyword\"> two three</span>",NULL,five,"<span class=\"keyword\">six</span> three"}
-- (1 row)
```

2.4.2から使えます。

以下は4つ目の使い方の説明です。

```text
text[] pgroonga_highlight_html(ARRAY[target1, target2, ...],
                               ARRAY[keyword1, keyword2, ...],
                               index_name)
```

`target1`、`target2`、`...`はハイライト対象のテキストです。型は`text`の配列です。

キーワードは`<span class="keyword">`と`</span>`で囲まれています。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

`index_name`には`NULL`を指定できます。

`NormalizerNFKC100`のように`NormalizerAuto`以外のノーマライザーを使っている場合は、`index_name`を使うとよいです。この関数はデフォルトで`NormalizerAuto`ノーマライザーを使います。これにより意図しない結果になることがあります。

`index_name`を指定した場合は、指定したPGroongaのインデックスには`"report_source_location"`オプションを指定した`TokenNgram`トークナイザーを指定しないといけません。

`pgroonga_highlight_html`は各`target`中のキーワードをマークアップします。`pgroonga_highlight_html`は`text`型の配列を返します。もし、ある`target`が`NULL`の場合は返ってくる配列の中の対応する要素も`NULL`になります。

キーワードは`<span class="keyword">`と`</span>`で囲まれます。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

2つ目の使い方の例と3つ目の使い方の例も見てください。

2.4.2から使えます。

## 使い方

少なくとも1つキーワードを指定しなければいけません。

```sql
SELECT pgroonga_highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['PostgreSQL']) AS highlight_html;
--                           highlight_html                          
-- ------------------------------------------------------------------
--  PGroonga is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

複数のキーワードを指定できます。

```sql
SELECT pgroonga_highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['Groonga', 'PostgreSQL']) AS highlight_html;
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

[`pgroonga_query_extract_keywords`関数](pgroonga-query-extract-keywords.html)を使うとクエリーからキーワードを抽出できます。

```sql
SELECT pgroonga_highlight_html('PGroonga is a PostgreSQL extension.',
                               pgroonga_query_extract_keywords('Groonga PostgreSQL -extension')) AS highlight_html;
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

HTMLの特別な文字は自動でエスケープされます。

```sql
SELECT pgroonga_highlight_html('<p>PGroonga is Groonga & PostgreSQL.</p>',
                               ARRAY['PostgreSQL']) AS highlight_html;
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  &lt;p&gt;PGroonga is Groonga &amp; <span class="keyword">PostgreSQL</span>.&lt;/p&gt;
-- (1 row)
```

文字は正規化されます。

```sql
SELECT pgroonga_highlight_html('PGroonga + pglogical = replicatable!',
                               ARRAY['Pg']) AS highlight_html;
--                                     highlight_html                                         
-- ------------------------------------------------------------------------------------------------
--  <span class="keyword">PG</span>roonga + <span class="keyword">pg</span>logical = replicatable!
-- (1 row)
```

マルチバイト文字にも対応しています。

```sql
SELECT pgroonga_highlight_html('10㌖先にある100ｷﾛグラムの米',
                               ARRAY['キロ']) AS highlight_html;
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  10<span class="keyword">㌖</span>先にある100<span class="keyword">ｷﾛ</span>グラムの米
-- (1 row)
```

PGroongaのインデックス名を指定するとトークナイザーとノーマライザーをカスタマイズできます。

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


## 参考

  * [`pgroonga_query_extract_keywords`関数][query-extract-keywords]

[query-extract-keywords]:pgroonga-query-extract-keywords.html
