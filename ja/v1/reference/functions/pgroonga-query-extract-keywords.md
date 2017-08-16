---
title: pgroonga.query_extract_keywords関数
upper_level: ../
---

# `pgroonga.query_extract_keywords`関数

1.0.7で追加。

## 概要

`pgroonga.query_extract_keywords`関数は[クエリー構文](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)を使っているテキストからキーワードを抽出します。クエリー構文は[`&@~`演算子][query-v2]や[`&@~|`演算子][query-in-v2]などで使われています。

クエリーからキーワードを抽出できると[`pgroonga.snippet_html`関数](pgroonga-snippet-html.html)や[`pgroonga.highlight_html`関数](pgroonga-highlight-html.html)などを使いやすくなります。これらにはキーワードを引数として渡さなければいけません。通常、渡すキーワードはクエリー内のキーワードになります。

## 構文

この関数の構文は次の通りです。

```text
text[] pgroonga.query_extract_keywords(query)
```

`query`は[クエリー構文](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)を使っている`text`型の値です。

`pgroonga.query_extract_keywords`はキーワードの配列を返します。

AND条件とOR条件の検索語はキーワードになります。NOT条件の検索語はキーワードになりません。たとえば、`"A (B OR C) - D"`では`A`と`B`と`C`はキーワードで`D`はキーワードではありません。`-`はNOT演算子です。

## 使い方

ANDのみの場合はすべての語がキーワードになります。

```sql
SELECT pgroonga.query_extract_keywords('Groonga PostgreSQL');
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

ORのみの場合はすべての語がキーワードになります。

```sql
SELECT pgroonga.query_extract_keywords('Groonga OR PostgreSQL');
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

カッコを使えます。

```sql
SELECT pgroonga.query_extract_keywords('Groonga (MySQL OR PostgreSQL)');
--    query_extract_keywords   
-- ----------------------------
--  {Groonga,PostgreSQL,MySQL}
-- (1 row)
```

NOT条件の語はキーワードになりません。

```sql
SELECT pgroonga.query_extract_keywords('Groonga - MySQL PostgreSQL');
--  query_extract_keywords 
-- ------------------------
--  {PostgreSQL,Groonga}
-- (1 row)
```

## 参考

  * [`pgroonga.snippet_html`関数](pgroonga-query-snippet-html.html)

  * [`pgroonga.highlight_html`関数](pgroonga-query-highlight-html.html)

  * [`pgroonga.match_positions_byte`関数](pgroonga-match-positions-byte.html)

[query-v2]:../operators/query-v2.html

[query-in-v2]:../operators/query-in-v2.html
