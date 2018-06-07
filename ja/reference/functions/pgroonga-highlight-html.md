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
```

1つ目の使い方は他の使い方よりもシンプルです。多くの場合は1つ目の使い方で十分です。

2つ目の使い方はノーマライザーを変更しているときに便利です。

2つ目の使い方は2.0.7から使えます。

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

`NormalizerNFKC100`のように`NormalizerAuto`以外のノーマライザーを使っている場合は、`index_name`を使うとよいです。`pgroonga_highlight_html`はデフォルトで`NormalizerAuto`ノーマライザーを使います。これにより意図しない結果になることがあります。

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
                                         highlight_html                                         
------------------------------------------------------------------------------------------------
 <span class="keyword">PG</span>roonga + <span class="keyword">pg</span>logical = replicatable!
(1 row)
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

## 参考

  * [`pgroonga_query_extract_keywords`関数][query-extract-keywords]

[query-extract-keywords]:pgroonga-query-extract-keywords.html
