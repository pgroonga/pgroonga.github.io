---
title: How to use auto complete feature
---

# How to use auto complete feature with PGroonga

PGroonga can't use Groonga's suggest plugin directly, so in this section, shows you an alternative way to implement auto complete feature.

There are some way to implement auto complete feature with PGroonga

* Use prefix search against auto complete candidate terms
* Use full text search against auto complete candidate terms
* Use romaji katakana search against auto complete candidate readings

You can use above methods in combination as you like.

## Sample schema and indexes

Here is the sample schema.

```
CREATE TABLE terms (
    term text,
    readings text[]
);
```

Auto complete candidate terms are stored into `term`. Readings of `term` are stored in `readings`. As you know, type of `readings` is `text[]`, multiple readings are stored into `readings`.

Here is the sample index definition.

```
CREATE INDEX pgroonga_terms_prefix_search ON terms USING pgroonga
  (term pgroonga.text_term_search_ops_v2,
   readings pgroonga.text_array_term_search_ops_v2);
CREATE INDEX pgroonga_terms_full_text_search ON terms USING pgroonga
  (term pgroonga.text_full_text_search_ops_v2);
```

Above indexes are required for prefix search and full text search.

## Use prefix search against auto complete candidate terms

There is a simple way to provide auto complete feature. It is prefix search.
PGroonga provides operator for it: [`&^` operator][prefix-search-v2]

Here is the sample data for prefix search.

```
INSERT INTO terms (term) VALUES ('autocomplete');
```

Then, use `&^` against `term` for prefix search. Here is the result of it.

```
SELECT term FROM terms WHERE term &^ 'auto';
--      term     
-- --------------
--  autocomplete
-- (1 rows)
```

The result contains `autocomplete` as auto complete candidate term.

## Use full text search against auto complete candidate terms

Use `&@` against `term` for full text search. Here is the result of it.

```
SELECT term FROM terms WHERE term &@ 'comp';
--      term     
-- --------------
--  autocomplete
-- (1 rows)
```

The result contains `autocomplete` as auto complete candidate term.

## Use prefix romaji katakana search against auto complete candidate readings

Here is the sample data for RK search.

```
INSERT INTO terms (term, readings) VALUES ('牛乳', ARRAY['ギュウニュウ', 'ミルク']);
```

Note that you need insert only katakana in `readings`. This is required to search auto complete candidate terms with prefix RK search.

Then use `&^~` against `readings` for prefix RK search. Here are some examples about prefix RK search.

* Prefix RK search with Hiragana
* Prefix RK search with Katanaka
* Prefix RK search with Romaji

```
SELECT term FROM terms WHERE readings &^~ 'ぎゅう';
--  term 
-- ------
--  牛乳
-- (1 row)
```

You can search "牛乳" as auto complete candidate of ぎゅう" (Hiragana) by prefix RK search.

```
SELECT term FROM terms WHERE readings &^~ 'ギュウ';
--  term 
-- ------
--  牛乳
-- (1 row)
```

You can also search "牛乳" as auto complete candidate of "ギュウ" (Katanaka) by prefix RK search.

```
SELECT term FROM terms WHERE readings &^~ 'gyu';
--  term 
-- ------
--  牛乳
-- (1 row)
```

You can also search "牛乳" as auto complete candidate of "gyu" (Romaji) by prefix RK search.

There is an advanced usage of `readings`. If reading of synonym is
stored in `readings`, you can also search as auto complete candidate
term.

```
SELECT term FROM terms WHERE readings &^~ 'mi';
--  term 
-- ------
--  牛乳
-- (1 row)
```

As the synonym of "牛乳" is "ミルク", so you can search it by 'mi' as auto complete candidate term because "ミルク" is stored in `readings` column.
