---
title: How to implement auto complete feature
---

# How to implement auto complete feature

Auto complete is useful feature for easy to use search box. PGroonga has features to implement auto complete.

You can implement auto complete by combining the following searches:

  * Only for Japanese: Prefix RK search for auto complete by readings

  * Loose full text search

## Sample schema and indexes

Here is the sample schema:

```sql
CREATE TABLE terms (
  term text,
  readings text[]
);
```

Auto complete candidate terms are stored into `term`. Readings of `term` are stored in `readings`. As you know, type of `readings` is `text[]`, multiple readings are stored into `readings`.

Here is the sample index definition:

```sql
CREATE INDEX pgroonga_terms_full_text_search ON terms USING pgroonga
  (term, readings)
  WITH (tokenizer = 'TokenBigramSplitSymbolAlphaDigit');
```

The above indexes are required for full text search.

`TokenBigramSplitSymbolAlphaDigit` tokenizer is suitable for loose full text search.

## Only for Japanese: Prefix RK search for auto complete by readings

[Prefix RK search][groonga-prefix-rk-search] is a prefix search variant. It supports searching [katakana][wikipedia-katakana] by [romaji][wikipedia-romaji], [hiragana][wikipedia-hiragana] or katakana. It's useful for Japanese.

Here is the sample data for prefix RK search:

```sql
INSERT INTO terms (term, readings) VALUES ('牛乳', ARRAY['ギュウニュウ', 'ミルク']);
```

Note that you need insert only katakana in `readings`. This is required to search auto complete candidate terms with prefix RK search.

Then use [`&^~` operator][prefix-rk-search-v2] against `readings` for prefix RK search. Here are some examples about prefix RK search.

  * Prefix RK search with romaji

  * Prefix RK search with hiragana

  * Prefix RK search with katanaka

You can search "牛乳" as auto complete candidate of "gyu" (romaji) by prefix RK search:

```sql
SELECT term FROM terms WHERE readings &^~ 'gyu';
--  term 
-- ------
--  牛乳
-- (1 row)
```

You can search "牛乳" as auto complete candidate of ぎゅう" (hiragana) by prefix RK search:

```sql
SELECT term FROM terms WHERE readings &^~ 'ぎゅう';
--  term 
-- ------
--  牛乳
-- (1 row)
```

You can search "牛乳" as auto complete candidate of "ギュウ" (katanaka) by prefix RK search.

```sql
SELECT term FROM terms WHERE readings &^~ 'ギュウ';
--  term 
-- ------
--  牛乳
-- (1 row)
```

There is an advanced usage of `readings`. If reading of synonym is stored in `readings`, you can also search as auto complete candidate term:

```sql
SELECT term FROM terms WHERE readings &^~ 'mi';
--  term 
-- ------
--  牛乳
-- (1 row)
```

"ミルク" is a synonym of "牛乳". You can search "牛乳" by "mi" as auto complete candidate term because "ミルク" is stored in `readings` column.

## Loose full text search

Use [`&@`][match-v2] against `term` for loose full text search. Here is the result of it:

```sql
SELECT term FROM terms WHERE term &@ 'mpl';
--      term      
-- ---------------
--  auto-complete
-- (1 rows)
```

The result contains `auto-complete` as auto complete candidate term.


[groonga-prefix-rk-search]:http://groonga.org/docs/reference/operations/prefix_rk_search.html

[wikipedia-katakana]:https://en.wikipedia.org/wiki/Katakana

[wikipedia-romaji]:https://en.wikipedia.org/wiki/Romanization_of_Japanese

[wikipedia-hiragana]:https://en.wikipedia.org/wiki/Hiragana

[match-v2]:../reference/operators/match-v2.html

[prefix-rk-search-v2]:../reference/operators/prefix-rk-search-v2.html
