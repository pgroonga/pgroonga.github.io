---
title: pgroonga_snippet_html関数
upper_level: ../
---

# `pgroonga_snippet_html`関数

## 概要

`pgroonga_snippet_html`関数は対象テキストの中からキーワード周辺のテキストを抽出して返します。これは[KWIC](https://ja.wikipedia.org/wiki/KWIC)（keyword in context）とも呼ばれています。Web検索エンジンの結果で使われていることが多いので見たことが多い人も多いでしょう。

## 構文

この関数の構文は次の通りです。

```text
text[] pgroonga_snippet_html(target, ARRAY[keyword1, keyword2, ...])
```

`target`は`text`型の値です。`pgroonga_snippet_html`は`target`の中からキーワード周辺のテキストを抽出します。

`keyword1`, `keyword2`, `...`は`text`型の配列です。これらのキーワードを`target`から抽出します。1つ以上のキーワードを指定する必要があります。

`pgroonga_snippet_html`は`text`型の配列を返します。

返ってくる配列の各要素はキーワード周辺のテキストです。

キーワードは`<span class="keyword">`と`</span>`で囲まれます。`target`中の`<`、`>`、`&`、`"`はHTMLエスケープされます。

各要素の`target`由来の部分の最大サイズは200バイトです。単位は文字数ではなくバイトです。各要素は200バイトより大きくなることがあります。なぜなら、各要素には`<span class="keyword">`と`</span>`が含まれますし、HTMLエスケープした値が含まれることもあるからです。もし、`<`がHTMLエスケープされると`&lt;`になり、バイトサイズは1から4に増えます。

## 使い方

[チュートリアルの中の例](../../tutorial/#snippet)も参考にしてください。

## 参考

  * [チュートリアルの中の例](../../tutorial/#snippet)

  * [`pgroonga_query_extract_keywords`関数][query-extract-keywords]

[query-extract-keywords]:pgroonga-query-extract-keywords.html
