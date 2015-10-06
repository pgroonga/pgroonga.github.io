---
title: CREATE INDEX USING pgroonga
layout: en
---

# `CREATE INDEX USING pgroonga`

You need to specify `USING pgroonga` to `CREATE INDEX` to use PGroonga as index method. This section describes about `pgroonga` index method.

## Syntax

This section describes only `pgroonga` index method related `CREATE INDEX` syntax. See [CREATE INDEX document by PostgreSQL](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/sql-createindex.html) for full `CREATE INDEX` syntax.

Here is a basic syntax for creating a single column index:

```sql
CREATE INDEX ${INDEX_NAME}
          ON ${TABLE_NAME}
       USING pgroonga (${COLUMN});
```

This syntax can be used for the following cases:

  * Creating a full text search index for a `text` type column
  * Creating a full text search index for an array of `text` type column
  * Creating a equality condition and comparison conditions search index for a non `text` type columns
  * Creating a equality condition and comparison conditions search index for an array of non `text` type columns
  * Creating a contain search and complex search index for `jsonb` type column

Here is a basic syntax for creating a full text search index for a `varchar` type column:

```sql
CREATE INDEX ${INDEX_NAME}
          ON ${TABLE_NAME}
       USING pgroonga (${COLUMN}) pgroonga.varchar_full_text_search_ops;
```

You need to specify `pgroonga.varchar_fulltext_search_ops` operator class for the case.

{: #customization}

### Customization

You can custom the followings by `WITH` option of `CREATE INDEX`:

  * Tokenizer: It's a module for full text search.
  * Normalizer: It's a module for customizing equality of `text` and `varchar` types.

Normally, you don't need to custom them because default values of them are suitable for most cases. Features to custom them are for advanced users.

Here are default tokenizer and normalizer:

  * Tokenizer: [`TokenBigram`](http://groonga.org/docs/reference/tokenizers.html#token-bigram): It's a bigram based tokenizer. It combines bigram tokenization and white space based tokenization. It uses bigram tokenization for non ASCII characters and white space based tokenization for ASCII characters. It reduces noise for ASCII characters only query.
  * Normalizer: [`NormalizerAuto`](http://groonga.org/docs/reference/normalizers.html#normalizer-auto): It chooses suitable normalization based on target encoding. For example, it uses [Unicode NFKC](http://unicode.org/reports/tr15/) based normalization for UTF-8.

#### How to custom tokenizer

Specify `tokenizer='${TOKENIZER_NAME}'` for customizing tokenizer. Normally, you don't need to custom tokenizer.

Here is an example to use [MeCab](http://taku910.github.io/mecab/) based tokenizer. You need to specify `tokenizer='TokenMecab'`. [`TokenMecab`](http://groonga.org/docs/reference/tokenizers.html#token-mecab) is a name of MeCab based tokenizer.

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenMecab');
```

You can disable tokenizer by specifying `tokenizer=''`. If you disable tokenizer, you can search column value only by exact match search and prefix search. It reduces noise for some cases. For example, it's useful for tag search, name search and so on.

Here is an example to disable tokenizer:

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (tokenizer='');
```

`tokenizer='TokenDelimit'` will be useful for tag search. See also [`TokenDelimit`](http://groonga.org/docs/reference/tokenizers.html#token-delimit).

See [Tokenizers](http://groonga.org/docs/reference/tokenizers.html) for other tokenizers.

#### How to custom normalizer

Specify `normalizer='${NORMALIZER_NAME}'` for customizing normalizer. Normally, you don't need to custom normalizer.

You can disable normalizer by specifying `normalizer=''`. If you disable normalizer, you can search column value only by the original column value. If normalizer increases noise, it's useful.

Here is an example to disable normalizer:

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizer='');
```

See [Normalizers](http://groonga.org/docs/reference/normalizers.html) for other normalizers.
