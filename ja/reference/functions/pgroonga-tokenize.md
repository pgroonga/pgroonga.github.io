---
title: pgroonga_tokenize関数
upper_level: ../
---

# `pgroonga_tokenize`関数

2.1.7で追加。

## 概要

`pgroonga_tokenize`関数は指定した[Groongaのノーマライザーモジュール][groonga-normalizers]・[Groongaのトークナイザーモジュール][groonga-tokenizers]・[Groongaのトークンフィルターモジュール（複数可）][groonga-token-filters]を使ってテキストをトークンにトークナイズします。

## 構文

この関数の構文は次の通りです。

```text
json[] pgroonga_tokenize(target,
                         'tokenizer', tokenizer,
                         'normalizer', normalizer,
                         'token_filters', token_filters)
```

`'tokenizer'`も`'normalizer'`も`'token_filters'`もすべて省略可能です。ただし、どれか1つは必ず指定しなければいけません。

たとえば、次はすべて正しいです。

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

しかし、次は間違っています。

```sql
SELECT pgroonga_tokenize('text');
```

`target`は`text`型の値です。トークナイズ対象のテキストです。

`tokenizer`は`text`型の値です。使用するトークナイザーモジュールを指定します。

`normalizer`は`text`型の値です。使用するノーマライザーモジュールを指定します。

`token_filters`は`text`型の値です。使用するトークンフィルター（複数可）を指定します。

トークナイズ結果は`json[]`型の値で返します。各要素はJSONでトークンを表現しています。各JSONは次のフォーマットになります。

```json
{
  "value": token,
  "position": position,
  "force_prefix_search": force_prefix_search
}
```

`token`はテキストです。

`position`は数値です。何番目のトークンかを示しています。

`force_prefix_search`は真偽値です。このトークンがプレフィックスサーチを使って処理されるべきかどうかを示しています。

トークンにはメタデータがあるかもしれません。メタデータがあるトークンは次のフォーマットになります。

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

メタデータ名と値はテキストです。

## 使い方

指定したトークナイザーで`text`型の値をトークナイズできます。

```sql
SELECT pgroonga_tokenize('aBcDe 123',
                         'tokenizer', 'TokenNgram');
-- {"{\"value\":\"aB\",\"position\":0,\"force_prefix_search\":false}",...}
```

結果のフォーマットには`jsonb_pretty`が便利です。

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

各モジュールにはオプションを指定できます。

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

## 参考

 * [Groongaのノーマライザーのドキュメント][groonga-normalizers]

 * [Groongaのトークナイザーのドキュメント][groonga-tokenizesrs]

 * [Groongaのトークンフィルターのドキュメント][groonga-token-filters]

[groonga-normalizers]:http://groonga.org/ja/docs/reference/normalizers.html

[groonga-tokenizers]:http://groonga.org/ja/docs/reference/tokenizers.html

[groonga-token-filters]:http://groonga.org/ja/docs/reference/token_filters.html
