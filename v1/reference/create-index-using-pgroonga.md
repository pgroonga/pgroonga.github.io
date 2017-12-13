---
title: CREATE INDEX USING pgroonga
---

# `CREATE INDEX USING pgroonga`

You need to specify `USING pgroonga` to `CREATE INDEX` to use PGroonga as index method. This section describes about `pgroonga` index method.

## Syntax

This section describes only `pgroonga` index method related `CREATE INDEX` syntax. See [`CREATE INDEX` document by PostgreSQL]({{ site.postgresql_doc_base_url.en }}/sql-createindex.html) for full `CREATE INDEX` syntax.

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
       USING pgroonga (${COLUMN} pgroonga.varchar_full_text_search_ops);
```

You need to specify `pgroonga.varchar_full_text_search_ops` operator class for the case.

### Customization {#customization}

You can customize the followings by `WITH` option of `CREATE INDEX`:

  * Plugin: It's an extension for Groonga. You can use additional features including additional tokenizers, normalizers and token filters by registering a plugin.

  * Tokenizer: It's a module for customizing how to extract keywords.

  * Normalizer: It's a module for customizing equality of `text` and `varchar` types.

  * Token filter: It's a module for filtering keywords extracted by tokenizer.

Normally, you don't need to customize them because the default values of them are suitable for most cases. Features to custom them are for advanced users.

Plugin and token filter aren't used by default.

Here are the default tokenizer and normalizer:

  * Tokenizer: [`TokenBigram`](http://groonga.org/docs/reference/tokenizers.html#token-bigram): It's a bigram based tokenizer. It combines bigram tokenization and white space based tokenization. It uses bigram tokenization for non ASCII characters and white space based tokenization for ASCII characters. It reduces noise for ASCII characters only query.

  * Normalizer: [`NormalizerAuto`](http://groonga.org/docs/reference/normalizers.html#normalizer-auto): It chooses suitable normalization based on target encoding. For example, it uses [Unicode NFKC](http://unicode.org/reports/tr15/) based normalization for UTF-8.

#### How to register plugins {#custom-plugins}

Since 1.2.0.

Specify `plugins='${PLUGIN_NAME_1}, ${PLUGIN_NAME_2}, ..., ${PLUGIN_NAME_N}'` for registering plugins.

Note that you must specify `plugins` as the first option in `CREATE INDEX`. Options in `CREATE INDEX` are processed by the specified order. Plugins should be registered before other options are processed because tokenizer, normalizer and token filters may be included in the plugins.

Here is an example to register `token_filters/stem` plugin to use `TokenFilterStem` token filter:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (plugins='token_filters/stem',
              token_filters='TokenFilterStem');
```

See [How to customize token filters](#custom-token-filters) for token filters details.

#### How to customize tokenizer {#custom-tokenizer}

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

#### How to customize normalizer {#custom-normalizer}

Specify `normalizer='${NORMALIZER_NAME}'` for customizing normalizer. Normally, you don't need to customize normalizer.

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

#### How to use token filters {#custom-token-filters}

Since 1.2.0.

Specify `token_filters='${TOKEN_FILTER_1}, ${TOKEN_FILTER_2}, ..., ${TOKEN_FILTER_N}'` for using token filters.

Groonga doesn't provide any token filters by default. All token filters are provided as plugins. You need to register plugins to use token filters.

Here is an example to use `TokenFilterStem` token filter that is included in `token_filters/stem` plugin:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (plugins='token_filters/stem',
              token_filters='TokenFilterStem');
```

Note that you must specify `plugins` before `token_filters`. These `CREATE INDEX` options are processed by the specified order. Plugins must be registered before you use token filters.

See [Token filters](http://groonga.org/docs/reference/token_filters.html) for other token filters.

#### How to change tablespace {#custom-tablespace}

Since 1.1.6.

Specify `TABLESPACE ${TABLESPACE_NAME}` for customizing [tablespace]({{ site.postgresql_doc_base_url.en }}/manage-ag-tablespaces.html). If you have fast storage, you may want to change tablespace for PGroonga indexes.

Here is an example to change tablespace:

```sql
CREATE TABLESPACE fast LOCATION '/data/fast_disk';

CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
  TABLESPACE fast;
```
