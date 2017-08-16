---
title: オートコンプリートの実装方法
---

# オートコンプリート機能の実装方法

オートコンプリートは使いやすい検索ボックスを作るのに便利な機能です。PGroongaにはオートコンプリートを実装するための機能があります。

次の検索を組み合わせることでオートコンプリートを実現できます。

  * 前方一致検索

  * 日本語のみ：ヨミガナでのオートコンプリート用に前方一致RK検索

  * 緩い全文検索

## サンプルスキーマとインデックス

サンプルのスキーマを示します。

```sql
CREATE TABLE terms (
  term text,
  readings text[]
);
```

オートコンプリート候補の用語は`term`に保存します。`term`のヨミガナは`readings`に保存します。`readings`の型が`text[]`であることからわかるように、`readings`には複数のヨミガナを保存できます。

サンプルのインデックス定義を示します。

```sql
CREATE INDEX pgroonga_terms_prefix_search ON terms USING pgroonga
  (term pgroonga_text_term_search_ops_v2,
   readings pgroonga_text_array_term_search_ops_v2);

CREATE INDEX pgroonga_terms_full_text_search ON terms USING pgroonga
  (term)
  WITH (tokenizer = 'TokenBigramSplitSymbolAlphaDigit');
```

上記のインデックス定義は前方一致検索と全文検索に必要です。

`TokenBigramSplitSymbolAlphaDigit`トークナイザーは緩い全文検索に向いています。

## 前方一致検索

オートコンプリート機能を実現するシンプルな方法は前方一致検索を使う方法です。

PGroongaは前方一致検索用の演算子として[`&^`演算子][prefix-search-v2]を提供しています。

前方一致検索をするためのサンプルデータを示します。

```sql
INSERT INTO terms (term) VALUES ('auto-complete');
```

データを挿入したら、`term`に対して`&^`を使って前方一致検索をします。結果は次の通りです。

```sql
SELECT term FROM terms WHERE term &^ 'auto';
--      term      
-- ---------------
--  auto-complete
-- (1 rows)
```

オートコンプリート候補の用語として`auto-complete`がヒットしています。

## 日本語のみ：ヨミガナでのオートコンプリート用に前方一致RK検索

[前方一致RK検索][groonga-prefix-rk-search]は前方一致検索の一種です。これは[ローマ字][wikipedia-romaji]、[ひらがな][wikipedia-hiragana]またはカタカナで[カタカナ][wikipedia-katakana]を検索できます。日本語にはとても便利な機能です。

前方一致RK検索のためのサンプルデータを示します。

```sql
INSERT INTO terms (term, readings) VALUES ('牛乳', ARRAY['ギュウニュウ', 'ミルク']);
```

`readings`にはカタカナのみ追加することに注意してください。これは前方一致RK検索を使ってオートコンプリート候補の用語を検索するのに必要です。

`readings`に対して前方一致RK検索をするために[`&^~`演算子][prefix-rk-search-v2]を使います。前方一致RK検索の例をいくつか示します。

  * ローマ字を使った前方一致RK検索

  * ひらがなを使った前方一致RK検索

  * カタカナを使った前方一致RK検索

前方一致RK検索では「gyu」（ローマ字）で「牛乳」をオートコンプリート候補の用語として検索できます。

```sql
SELECT term FROM terms WHERE readings &^~ 'gyu';
--  term 
-- ------
--  牛乳
-- (1 row)
```

前方一致RK検索では「ぎゅう」（ひらがな）で「牛乳」をオートコンプリート候補として検索できます。

```sql
SELECT term FROM terms WHERE readings &^~ 'ぎゅう';
--  term 
-- ------
--  牛乳
-- (1 row)
```

前方一致RK検索では「ギュウ」（カタカナ）で「牛乳」をオートコンプリート候補の用語として検索できます。

```sql
SELECT term FROM terms WHERE readings &^~ 'ギュウ';
--  term 
-- ------
--  牛乳
-- (1 row)
```

より高度な`readings`の使い方があります。同義語の読みを`readings`に入れると、それを使ってオートコンプリート候補の用語を検索することもできます。

```sql
SELECT term FROM terms WHERE readings &^~ 'mi';
--  term 
-- ------
--  牛乳
-- (1 row)
```

「ミルク」は「牛乳」の同義語です。ヨミガナとして「ミルク」を`readings`に追加することで、「mi」で検索したときも「牛乳」をオートコンプリート候補の用語として検索できます。

## 緩い全文検索

緩い全文検索をするために`term`に対して[`&@`][match-v2]を使います。結果は次の通りです。

```sql
SELECT term FROM terms WHERE term &@ 'mpl';
--      term      
-- ---------------
--  auto-complete
-- (1 rows)
```

オートコンプリート候補の用語として`auto-complete`がヒットしています。


[groonga-prefix-rk-search]:http://groonga.org/ja/docs/reference/operations/prefix_rk_search.html

[wikipedia-katakana]:https://ja.wikipedia.org/wiki/%E7%89%87%E4%BB%AE%E5%90%8D

[wikipedia-romaji]:https://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97

[wikipedia-hiragana]:https://ja.wikipedia.org/wiki/%E5%B9%B3%E4%BB%AE%E5%90%8D

[prefix-search-v2]:../reference/operators/prefix-search-v2.html

[match-v2]:../reference/operators/match-v2.html

[prefix-rk-search-v2]:../reference/operators/prefix-rk-search-v2.html
