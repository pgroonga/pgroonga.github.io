---
title: pgroonga_tokenize function
upper_level: ../
---

# `pgroonga_tokenize` function

Since 2.1.7.

## Summary

`pgroonga_tokenize` function tokenizes a text into tokens using a [Groonga's normalizer module][groonga-normalizers], [Groonga's tokenizer module][groonga-tokenizers] and [Groonga's token filter modules][groonga-token-filters].

## Syntax

Here is the syntax of this function:

```text
json[] pgroonga_tokenize(target,
                         'tokenizer', tokenizer,
                         'normalizer', normalizer,
                         'token_filters', token_filters)
```

All of `'tokenizer'`, `'normalizer'` and `'token_filters'` are optional. But you must specify one of them.

For example, the followings are all valid:

```sql
SELECT pgroonga_tokenize('text',
                         'tokenizer', 'TokenBigram');
SELECT pgroonga_tokenize('text',
                         'normalizer', 'NormalizerNFKC100');
SELECT pgroonga_tokenize('text',
                         'token_filters', 'TokenFilterNFKC100');
SELECT pgroonga_tokenize('text',
                         'tokenizer', 'TokenBigram',
                         'normalizer', 'NormalizerNFKC100');
SELECT pgroonga_tokenize('text',
                         'tokenizer', 'TokenBigram',
                         'token_filters', 'TokenFilterNFKC100');
SELECT pgroonga_tokenize('text',
                         'normalizer', 'NormalizerNFKC100',
                         'token_filters', 'TokenFilterNFKC100');
SELECT pgroonga_tokenize('text',
                         'tokenizer', 'TokenBigram',
                         'normalizer', 'NormalizerNFKC100',
                         'token_filters', 'TokenFilterNFKC100');
```

But the following is invalid:

```sql
SELECT pgroonga_tokenize('text');
```

`target` is a `text` type value to be tokenized.

`tokenizer` is a `text` type value which specifies the tokenizer module you want to use.

`normalizer` is a `text` type value which specifies the normalizer module you want to use.

`token_filters` is a `text` type value which specifies the token filter modules you want to use.

It returns tokenized result as `json[]` type. Each element represents a token by JSON. Each JSON uses the following format:

```json
{
  "value": token,
  "position": position,
  "force_prefix_search": force_prefix_search
}
```

`token` is a text.

`position` is a number that shows the number of token.

`force_prefix_search` is a boolean that shows the token should be processed with prefix search.

A token may have metadata. Token that has metadata use the following format:

```json
{
  "value": token,
  "position": position,
  "force_prefix_search": force_prefix_search,
  "metadata": {
    "metadata_name_1": "metadata_value_1",
    "metadata_name_2": "metadata_value_2",
    ...
    "metadata_name_N": "metadata_value_N"
  }
}
```

Both of metadata name and value are text.

## Usage

You can tokenize a `text` type value with the specified tokenizer:

```sql
SELECT pgroonga_tokenize('aBcDe 123',
                         'tokenizer', 'TokenNgram');
-- {"{\"value\":\"aB\",\"position\":0,\"force_prefix_search\":false}",...}
```

You can use `jsonb_pretty` to format the output:

```sql
SELECT jsonb_pretty(token::jsonb)
  FROM (
    SELECT unnest(pgroonga_tokenize('aBcDe 123',
                                    'tokenizer', 'TokenNgram'))
      AS token
  ) AS tokens;
--            jsonb_pretty           
-- ----------------------------------
--  {                               +
--      "value": "aB",              +
--      "position": 0,              +
--      "force_prefix_search": false+
--  }
--  {                               +
--      "value": "Bc",              +
--      "position": 1,              +
--      "force_prefix_search": true +
--  }
--  {                               +
--      "value": "cD",              +
--      "position": 2,              +
--      "force_prefix_search": true +
--  }
--  {                               +
--      "value": "De",              +
--      "position": 3,              +
--      "force_prefix_search": true +
--  }
--  {                               +
--      "value": "e ",              +
--      "position": 4,              +
--      "force_prefix_search": true +
--  }
--  {                               +
--      "value": " 1",              +
--      "position": 5,              +
--      "force_prefix_search": true +
--  }
--  {                               +
--      "value": "12",              +
--      "position": 6,              +
--      "force_prefix_search": true +
--  }
--  {                               +
--      "value": "23",              +
--      "position": 7,              +
--      "force_prefix_search": true +
--  }
--  {                               +
--      "value": "3",               +
--      "position": 8,              +
--      "force_prefix_search": true +
--  }
-- (9 rows)
```

You can specify options to each modules:

```sql
SELECT jsonb_pretty(token::jsonb)
  FROM (
    SELECT unnest(
      pgroonga_tokenize('This is a pen. これはペンです。',
                        'tokenizer', 'TokenMecab("include_class", true)',
                        'token_filters', 'TokenFilterNFKC100("unify_kana", true)'))
      AS token
  ) AS tokens;
--              jsonb_pretty              
-- ---------------------------------------
--  {                                    +
--      "value": "this",                 +
--      "metadata": {                    +
--          "class": "名詞",             +
--          "subclass0": "固有名詞",     +
--          "subclass1": "組織"          +
--      },                               +
--      "position": 0,                   +
--      "force_prefix_search": false     +
--  }
--  {                                    +
--      "value": "i",                    +
--      "metadata": {                    +
--          "class": "記号",             +
--          "subclass0": "アルファベット"+
--      },                               +
--      "position": 1,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "s",                    +
--      "metadata": {                    +
--          "class": "記号",             +
--          "subclass0": "アルファベット"+
--      },                               +
--      "position": 2,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "a",                    +
--      "metadata": {                    +
--          "class": "記号",             +
--          "subclass0": "アルファベット"+
--      },                               +
--      "position": 3,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "pen",                  +
--      "metadata": {                    +
--          "class": "名詞",             +
--          "subclass0": "一般"          +
--      },                               +
--      "position": 4,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": ".",                    +
--      "metadata": {                    +
--          "class": "記号",             +
--          "subclass0": "句点"          +
--      },                               +
--      "position": 5,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "これ",                 +
--      "metadata": {                    +
--          "class": "名詞",             +
--          "subclass0": "代名詞",       +
--          "subclass1": "一般"          +
--      },                               +
--      "position": 6,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "は",                   +
--      "metadata": {                    +
--          "class": "助詞",             +
--          "subclass0": "係助詞"        +
--      },                               +
--      "position": 7,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "ぺん",                 +
--      "metadata": {                    +
--          "class": "名詞",             +
--          "subclass0": "一般"          +
--      },                               +
--      "position": 8,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "です",                 +
--      "metadata": {                    +
--          "class": "助動詞"            +
--      },                               +
--      "position": 9,                   +
--      "force_prefix_search": true      +
--  }
--  {                                    +
--      "value": "。",                   +
--      "metadata": {                    +
--          "class": "記号",             +
--          "subclass0": "句点"          +
--      },                               +
--      "position": 10,                  +
--      "force_prefix_search": true      +
--  }
-- (11 rows)
```

## See also

 * [Groonga document for normalizers][groonga-normalizers]

 * [Groonga document for tokenizers][groonga-tokenizers]

 * [Groonga document for token filters][groonga-token-filters]

[groonga-normalizers]:http://groonga.org/docs/reference/normalizers.html

[groonga-tokenizers]:http://groonga.org/docs/reference/tokenizers.html

[groonga-token-filters]:http://groonga.org/docs/reference/token_filters.html
