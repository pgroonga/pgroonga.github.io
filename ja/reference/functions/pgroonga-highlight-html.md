---
title: pgroonga.highlight_html関数
layout: ja
---

# `pgroonga.highlight_html`関数

1.0.7で追加。

## 概要

`pgroonga.highlight_html`関数は指定したテキスト中にある指定したキーワードを`<span class="keyword">`と`</span>`で囲みます。指定したテキスト中にある`&`などのHTMLの特別な文字はエスケープされます。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.highlight_html(target, ARRAY[keyword1, keyword2, ...])
```

`target`はハイライト対象のテキストです。型は`text`です。

キーワードは`<span class="keyword">`と`</span>`で囲まれています。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

`pgroonga.highlight_html`は`target`中のキーワードをマークアップします。型は`text`です。

キーワードは`<span class="keyword">`と`</span>`で囲まれます。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

## 使い方

少なくとも1つキーワードを指定しなければいけません。

```sql
SELECT pgroonga.highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['PostgreSQL']);
--                           highlight_html                          
-- ------------------------------------------------------------------
--  PGroonga is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

複数のキーワードを指定できます。

```sql
SELECT pgroonga.highlight_html('PGroonga is a PostgreSQL extension.',
                               ARRAY['Groonga', 'PostgreSQL']);
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

[`pgroonga.query_extract_keywords`関数](pgroonga-query-extract-keywords.html)を使うとクエリーからキーワードを抽出できます。

```sql
SELECT pgroonga.highlight_html('PGroonga is a PostgreSQL extension.',
                               pgroonga.query_extract_keywords('Groonga PostgreSQL -extension'));
--                                         highlight_html                                         
-- -----------------------------------------------------------------------------------------------
--  P<span class="keyword">Groonga</span> is a <span class="keyword">PostgreSQL</span> extension.
-- (1 row)
```

HTMLの特別な文字は自動でエスケープされます。

```sql
SELECT pgroonga.highlight_html('<p>PGroonga is Groonga & PostgreSQL.</p>',
                               ARRAY['PostgreSQL']);
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  &lt;p&gt;PGroonga is Groonga &amp; <span class="keyword">PostgreSQL</span>.&lt;/p&gt;
-- (1 row)
```

文字は正規化されます。

```sql
SELECT pgroonga.highlight_html('PGroonga + pglogical = replicatable!',
                               ARRAY['Pg']);
                                         highlight_html                                         
------------------------------------------------------------------------------------------------
 <span class="keyword">PG</span>roonga + <span class="keyword">pg</span>logical = replicatable!
(1 row)
```

マルチバイト文字にも対応しています。

```sql
SELECT pgroonga.highlight_html('10㌖先にある100ｷﾛグラムの米',
                               ARRAY['キロ']);
--                                     highlight_html                                     
-- ---------------------------------------------------------------------------------------
--  10<span class="keyword">㌖</span>先にある100<span class="keyword">ｷﾛ</span>グラムの米
-- (1 row)
```

## 参考

  * [`pgroonga.query_extract_keywords`関数](pgroonga-query-extract-keywords.html)
