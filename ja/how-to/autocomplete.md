---
title: PGroongaでオートコンプリートをする方法
---

PGroongaでオートコンプリートをする方法

PGroongaはGroongaのサジェストプラグインを直接使うことができません。そのためこのハウツーではPGroongaでオートコンプリートを実現する代替案を紹介します。

PGroongaでオートコンプリートを実装するにはいくつかやり方があります。

* オートコンプリート候補の用語に対して前方一致検索をする
* オートコンプリート候補の用語に対して全文検索をする
* オートコンプリート候補の用語の読みに対してローマ字カタカナ検索をする

上記の方法を好きなように組み合わせて使うことができます。

## サンプルのスキーマとインデックスの定義

サンプルのスキーマを示します。

```
CREATE TABLE terms (
    term text,
    readings text[]
);
```

オートコンプリートの候補となる用語は `term` に保存されます。 `term` の読みは `readings` へと保存されます。 `readings` の型が `text[]` であることからわかるように、複数の読みが `readings` には保存できます。

サンプルのインデックス定義を示します。

```
CREATE INDEX pgroonga_terms_prefix_search ON terms USING pgroonga
  (term pgroonga.text_term_search_ops_v2,
   readings pgroonga.text_array_term_search_ops_v2);
CREATE INDEX pgroonga_terms_full_text_search ON terms USING pgroonga
  (term pgroonga.text_full_text_search_ops_v2);
```

上記のインデックス定義は前方一致検索や全文検索に必要です。

## オートコンプリート候補の用語に対して前方一致検索

オートコンプリート機能を提供するシンプルな方法です。前方一致を使います。PGroongaはそのための演算子として [`&^`演算子][prefix-search-v2]を提供しています。

前方一致検索をするためのサンプルデータを示します。

```
INSERT INTO terms (term) VALUES ('autocomplete');
```

そして、前方一致検索するため `term` に対して `&^` を使います。結果は次の通りです。

```
SELECT term FROM terms WHERE term &^ 'auto';
--      term     
-- --------------
--  autocomplete
-- (1 rows)
```

結果には `autocomplete` がオートコンプリート候補の用語として含まれます。

## オートコンプリート候補の用語に対して全文検索

`term` を全文検索するには `&@` を使います。結果は次の通りです。

```
SELECT term FROM terms WHERE term &@ 'comp';
--      term     
-- --------------
--  autocomplete
-- (1 rows)
```

結果には `autocomplete` がオートコンプリート候補の用語として含まれます。

## オートコンプリート候補の用語の読みに対してローマ字カタカナ前方一致検索

RK検索のためのサンプルデータを示します。

```
INSERT INTO terms (term, readings) VALUES ('牛乳', ARRAY['ギュウニュウ', 'ミルク']);
```

`readings` にはカタカナのみ追加することに注意してください。これは前方一致RK検索を使ってオートコンプリート候補の用語を検索するのに必要です。

そして、 `term` に対して前方一致RK検索をするのに `&^~` を使います。前方一致RK検索の例を示します。

* 前方一致RK検索(ひらがな)
* 前方一致RK検索(カタカナ)
* 前方一致RK検索(ローマ字)

```
SELECT term FROM terms WHERE readings &^~ 'ぎゅう';
--  term 
-- ------
--  牛乳
-- (1 row)
```

前方一致RK検索によって「ぎゅう」(ひらがな)から"牛乳"をオートコンプリート候補として検索することができました。

```
SELECT term FROM terms WHERE readings &^~ 'ギュウ';
--  term 
-- ------
--  牛乳
-- (1 row)
```

前方一致RK検索では「ギュウ」(カタカナ)で"牛乳"をオートコンプリート候補の用語として検索することもできます。

```
SELECT term FROM terms WHERE readings &^~ 'gyu';
--  term 
-- ------
--  牛乳
-- (1 row)
```

前方一致RK検索では「gyu」(ローマ字)で"牛乳"をオートコンプリート候補の用語として検索することもできます。

より高度な `readings` の使い方があります。同義語の読みを `readings` に入れると、それを使ってオートコンプリート候補の用語を検索することもできます。

```
SELECT term FROM terms WHERE readings &^~ 'mi';
--  term 
-- ------
--  牛乳
-- (1 row)
```

"牛乳"の同義語は"ミルク"ですが、"ミルク" を `readings` に読みとして追加することで、'mi'で検索したときも"牛乳"をオートコンプリート候補の用語として検索できます。
