---
title: pgroonga_snippet_html関数
upper_level: ../
---

# `pgroonga_snippet_html`関数

## 概要

`pgroonga_snippet_html`関数は対象テキストの中からキーワード周辺のテキストを抽出して返します。これは[KWIC](https://ja.wikipedia.org/wiki/KWIC)（keyword in context）とも呼ばれています。Web検索エンジンの結果で使われていることが多いので見たことが多い人も多いでしょう。

## 構文

使い方は2つあります。

```text
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...])
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...], width)
```

2番めの使い方は、スニペットの長さをカスタマイズするときに便利です。

2番めの使い方は 2.4.2 から使えます。

以下は1つ目の使い方の説明です。

```text
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...])
```

`target`は`text`型の値です。`pgroonga_snippet_html`は`target`の中からキーワード周辺のテキストを抽出します。

`keyword1`, `keyword2`, `...`は`text`型の配列です。これらのキーワードを`target`から抽出します。1つ以上のキーワードを指定する必要があります。

以下は2つ目の使い方の説明です。

```text
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...], width)
```

`target`は`text`型の値です。`pgroonga_snippet_html`は`target`の中からキーワード周辺のテキストを抽出します。

`keyword1`, `keyword2`, `...`は`text`型の配列です。これらのキーワードを`target`から抽出します。1つ以上のキーワードを指定する必要があります。

`width` は `integer`型の値です。この引数は省略可能です。 `width` のデフォルト値は 200 です。

この引数でスニペットの長さを動的に指定できます。

`pgroonga_snippet_html`は`text`型の配列を返しますが、 `width` にキーワードより少ない長さを指定するとレコードを出力しません。

返ってくる配列の各要素はキーワード周辺のテキストです。

キーワードは`<span class="keyword">`と`</span>`で囲まれます。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

各要素の`target`由来の部分の最大サイズは200バイトです。単位は文字数ではなくバイトです。各要素は200バイトより大きくなることがあります。なぜなら、各要素には`<span class="keyword">`と`</span>`が含まれますし、HTMLエスケープした値が含まれることもあるからです。もし、`<`がHTMLエスケープされると`&lt;`になり、バイトサイズは1から4に増えます。

## 使い方

例えば、スニペットの長さを調整したい場合は、 `width` 引数を以下のように使います。

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

[チュートリアルの中の例](../../tutorial/#snippet) も参照してください。

## 参考

  * [チュートリアルの中の例](../../tutorial/#snippet)

  * [`pgroonga_query_extract_keywords`関数][query-extract-keywords]

[query-extract-keywords]:pgroonga-query-extract-keywords.html
