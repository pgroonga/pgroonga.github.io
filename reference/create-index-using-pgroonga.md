---
title: CREATE INDEX USING pgroonga
toc: true
---

# `CREATE INDEX USING pgroonga`

You need to specify `USING pgroonga` to `CREATE INDEX` to use PGroonga as index method. This section describes about `pgroonga` index method.

## Syntax {#syntax}

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
       USING pgroonga (${COLUMN} pgroonga_varchar_full_text_search_ops_v2);
```

You need to specify `pgroonga_varchar_full_text_search_ops_v2` operator class for the case.

You can also use `INCLUDE` since 2.3.5.

### Customization {#customization}

You can customize the followings by `WITH` option of `CREATE INDEX`:

  * Plugin: It's an extension for Groonga. You can use additional features including additional tokenizers, normalizers and token filters by registering a plugin.

  * Tokenizer: It's a module for customizing how to extract keywords.

  * Normalizer: It's a module for customizing equality of `text` and `varchar` types.

  * Token filter: It's a module for filtering keywords extracted by tokenizer.

  * Lexicon type: It's a type for lexicon that manages tokens.

  * Query syntax: It's the syntax used by [`$@~` operator][query-v2].

Normally, you don't need to customize them because the default values of them are suitable for most cases. Features to customize them are for advanced users.

Plugin and token filter aren't used by default.

Here are the default tokenizer, normalizer and lexicon type:

  * Tokenizer: [`TokenBigram`][groonga-token-bigram]: It's a bigram based tokenizer. It combines bigram tokenization and white space based tokenization. It uses bigram tokenization for non ASCII characters and white space based tokenization for ASCII characters. It reduces noise for ASCII characters only query.

  * Normalizer: [`NormalizerAuto`][groonga-normalizer-auto]: It chooses suitable normalization based on target encoding. For example, it uses [Unicode NFKC][unicode-nfkc] based normalization for UTF-8.

  * Lexicon type: [`patricia_trie`][groonga-table-patricia-trie]: It supports rich token search features such as predictive search. Its size is small.

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

Specify `tokenizer='${TOKENIZER_NAME}'` for customizing tokenizer. Normally, you don't need to customize tokenizer.

Here is an example to use [MeCab][mecab] based tokenizer. You need to specify `tokenizer='TokenMecab'`. [`TokenMecab`][groonga-token-mecab] is a name of MeCab based tokenizer.

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

`tokenizer='TokenDelimit'` will be useful for tag search. See also [`TokenDelimit`][groonga-token-delimit].

You can specify tokenizer options by `tokenizer='${TOKENIZER_NAME}(...)'` syntax.

It's available since 2.0.6.

Here is an example to use `TokenNgram` tokenizer with `"n"` and `3` options:

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (tokenizer='TokenNgram("n", 3)');
```

See [Tokenizers][groonga-tokenizers] for other tokenizers.

#### Partial match in alphabetic languages {#partial-match-alphabetic-languages}

If you plan to perform partial matching searches for keywords in alphabetic languages, it is recommended to configure your tokenizer to `TokenNgram` with extra options. The default tokenizer in `PGroonga` is `TokenBigram`, which means that if you search for the keyword 'pp', for instance, it won't match 'Apple', 'Pineapple', or 'Ripple' in your data. To avoid this issue, it is strongly advised to set up your tokenizer as following `TokenNgram` example.

Here is an example to use `TokenNgram` based tokenizer. You need to specify `tokenizer='TokenNgram'`. See [`TokenNgram`][groonga-token-ngram] for more detail.

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH(tokenizer='TokenNgram("unify_alphabet", false, "unify_symbol", false, "unify_digit", false)');
```

You may also use `TokenBigramBigramSplitSymbolAlphaDigit` for partial match instead of `TokenNgram` above. **(Using `TokenNgram(...)` is recommended)**.

**Remarks**
We however do not recommend using `TokenNgram("unify_...)`. It is advisable to use `TokenNgram/TokenBigram` instead, as partial matches in alphabetical languages tend to introduce a lot of noise. `TokenNgram("unify_...)` should only be utilized when it is truly necessary.

#### How to customize normalizer {#custom-normalizer}

You can use the following parameters to customize normalizer. Normally, you don't need to customize normalizer.

  * `normalizers`: The default normalizers that are used when the following parameters aren't used.

    * Since 2.3.1.

  * `normalizer`: Same as `normalizers`. This is deprecated since 2.3.1.

  * `full_text_search_normalizer`: Normalizer that is used for full text search index when `normalizers_mapping` doesn't specify normalizer for the index target.

  * `regexp_search_normalizer`: Normalizer that is used for regular expression search index when `normalizers_mapping` doesn't specify normalizer for the index target.

  * `prefix_search_normalizer`: Normalizer that is used for prefix search index when `normalizers_mapping` doesn't specify normalizer for the index target.

  * `normalizers_mapping`: You can specify normalizer for the specified index target.

    * Since 2.3.1.

You can disable normalizer by specifying empty value such as `normalizers=''`. If you disable normalizer, you can search column value only by the original column value. If normalizer increases noise, it's useful.

Here is an example to disable normalizer:

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizers='');
```

You can specify normalizer options by `normalizers='${NORMALIZER_NAME}(...)'` syntax.

It's available since 2.0.6.

Here is an example to use `NormalizerNFKC100` normalizer with `"unify_kana"` and `true` options:

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizers='NormalizerNFKC100("unify_kana", true)');
```

You can specify multiple normalizers by `normalizers='${NORMALIZER_NAME1}(...), ${NORMALISER_NAME2(...), ...'` syntax.

It's available since 2.3.1.

Here is a useless example to use `NormalizerNFKC130` normalizer with `"unify_kana"` and `true` option and `NormalizerNFKC130` with `"unify_hyphen"` and `true` option:

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizers='
                NormalizerNFKC130("unify_kana", true),
                NormalizerNFKC130("unify_hyphen", true)
              ');
```

See [Normalizers][groonga-normalizers] for other normalizers.

You can use other custom normalizer for full text search, regular expression search and prefix search separately. Here are sample operator classes for them:

  * Full text search: [`pgroonga_text_full_text_search_ops_v2`][text-full-text-search-ops-v2]

  * Regular expression search: [`pgroonga_text_regexp_ops_v2`][text-regexp-ops-v2]

  * Prefix search: [`pgroonga_text_term_search_ops_v2`][text-term-search-ops-v2]

You can use different normalizer for each search operations by the following parameters.

  * Full text search: `full_text_search_normalizer`

  * Regular expression search: `regexp_search_normalizer`

  * Prefix search: `prefix_search_normalizer`

If they aren't used, the `normalizers` parameter is used as fallback.

Here is an example to disable normalizer only for full text search:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (full_text_search_normalizer='',
              normalizers='NormalizerAuto');
```

The index for `title` is for full text search. It doesn't use normalizer because `full_text_search_normalizer` is `''`. Other indexes use `NormalizerAuto` because `normalizer` is `'NormalizerAuto'`.

Here is an example to disable normalizer only for regular expression search:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (regexp_search_normalizer='',
              normalizers='NormalizerAuto');
```

The index for `content` is for regular expression search. It doesn't use normalizer because `regexp_search_normalizer` is `''`. Other indexes use `NormalizerAuto` because `normalizers` is `'NormalizerAuto'`.

Here is an example to disable normalizer only for prefix search:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (prefix_search_normalizer='',
              normalizers='NormalizerAuto');
```

The index for `tag` is for term search that includes prefix search. It doesn't use normalizer because `prefix_search_normalizer` is `''`. Other indexes use `NormalizerAuto` because `normalizers` is `'NormalizerAuto'`.

You can use `normalizers_mapping='${MAPPING_IN_JSON}'` to specify normalizers for the specified index targets.

It's available since 2.3.1.

Here is the syntax of `${MAPPING_IN_JSON}`:

```json
{
  "${index_target_name1}": "${normalizer1}",
  "${index_target_name2}": "${normalizer2}",
  ...
}
```

Here is an example to use `NormalizerNFKC130("unify_kana", true)` normalizer for `title`, `NormalizerNFKC130("unify_hyphen", true)` normalizer for `content` and `NormalizerAuto` for other columns:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (normalizers_mapping='{
                "title": "NormalizerNFKC130(\"unify_kana\", true)",
                "content": "NormalizerNFKC130(\"unify_hyphen\", true)"
              }',
              normalizers='NormalizerAuto');
```

##### How to use `NormalizerTable` {#normalizer-table}

You can use `${table:PGROONGA_INDEX_NAME}` syntax in text that specifies normalizers.

It's available since 2.3.1.

It's substituted with table name in Groonga corresponding to the PGroonga's index specified as `PGROONGA_INDEX_NAME`. This is useful for [`NormalizerTable`][groonga-normalizer-table] that requires table and column names in Groonga.

Here is an example to use `NormalizerNFKC130` normalizer and `NormalizerTable` normalizer:

```sql
CREATE TABLE normalizations (
  target text,
  normalized text
);

CREATE INDEX pgrn_normalizations_index ON normalizations
 USING pgroonga (target pgroonga_text_term_search_ops_v2,
                 normalized);

INSERT INTO normalizations VALUES ('o', '0');
INSERT INTO normalizations VALUES ('ss', '55');

CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content)
        WITH (normalizers='
                NormalizerNFKC130,
                NormalizerTable(
                  "normalized", "${table:pgrn_normalizations_index}.normalized",
                  "target", "target"
                )
             ');

INSERT INTO memos VALUES (1, '0123455');
INSERT INTO memos VALUES (2, 'o1234ss');

SELECT * FROM memos WHERE content &@~ 'o123455';
--  id | content 
-- ----+---------
--   1 | 0123455
--   2 | o1234ss
-- (2 rows)
```

Note that you need to run `REINDEX INDEX pgroonga_memos_index` after you change `normalizations` table. Because normalization results are changed after `normalizations` table is changed.

**Special Case: Using with `pgroonga_highlight_html`**

When you need using `pgroonga_highlight_html` function with this `NormalizerTable`, you need to specify not only `TokenNgram` with `"report_source_location", true"` option but also both `Normalizer` and `NormalizerTable` with `"report_source_offset", true"` option for each.

Please reference [pgroonga_highlight_html](./functions/pgroonga-highlight-html.html) for details.

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

See [Token filters][groonga-token-filters] for other token filters.

#### How to customize tablespace {#custom-tablespace}

Since 1.1.6.

Specify `TABLESPACE ${TABLESPACE_NAME}` for customizing [tablespace][postgresql-tablespace]. If you have fast storage, you may want to change tablespace for PGroonga indexes.

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

#### How to customize lexicon type {#custom-lexicon-type}

Since 2.0.6.

Specify `lexicon_type='${LEXICON_TYPE}'` for customizing lexicon type.

Here are available lexicon types:

  * [`hash_table`][groonga-table-hash-table]

  * [`patricia_trie`][groonga-table-patricia-trie]

    * Default

  * [`double_array_trie`][groonga-table-double-array-trie]

Normally, you don't need to customize this because the default value is suitable for most cases.

Here is an example to use `hash_table` lexicon type to disable predictive token search:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (lexicon_type='hash_table');
```

#### How to use `column:...` syntax in query {#query-allow-column}

Since 2.1.3.

Specify `query_allow_column=true` to use `column:...` syntax in query.

If you use `column:...` syntax, you can use other columns and not only match operations but also other operations.

Note that `column:...` syntax doesn't work with sequential search. It works only with index search.

Here is an example to use `query_allow_column` to use other column in the same index:

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memo_texts_index
          ON memos
       USING pgroonga (title, content)
        WITH (query_allow_column=true);

INSERT INTO memos VALUES
  ('PGroonga = PostgreSQL + Groonga', 'Very fast full text search extension.'),
  ('PostGIS', 'GIS extension.');

SELECT *
  FROM memos
    -- The content column must have 'extension' and
    -- the title column must have 'Groonga'.
 WHERE content &@~ 'extension title:@Groonga';
--               title              |                content                
-- ---------------------------------+---------------------------------------
--  PGroonga = PostgreSQL + Groonga | Very fast full text search extension.
-- (1 row)
```

Here is an example to use `query_allow_column` to use other operation:

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text
);

CREATE INDEX pgroonga_title_index
          ON memos
       USING pgroonga (title)
        WITH (query_allow_column=true);

INSERT INTO memos VALUES ('PGroonga');
INSERT INTO memos VALUES ('PGroonga = PostgreSQL + Groonga');

SELECT *
  FROM memos
    -- The title column must equal to 'PGroonga'.
    -- Note that this operation doesn't use index.
 WHERE title &@~ 'title:PGroonga';
--   title   
-- ----------
--  PGroonga
-- (1 row)
```

See [Groonga's query syntax][groonga-query-syntax] for available operations.

#### How to customize index column flags {#custom-index-flags}

Since 2.3.2.

Specify `index_flags_mappings='${MAPPING_IN_JSON}'` for customizing index column flags for the specified index target.

Here is the syntax of `${MAPPING_IN_JSON}`:

```json
{
  "${index_target_name1}": "${flags1}",
  "${index_target_name2}": "${flags2}",
  ...
}
```

Here are available index column flags that are corresponding to [flags in Groonga][groonga-index-column-flags]:

  * `SMALL`: `INDEX_SMALL` in Groonga

  * `MEDIUM`: `INDEX_MEDIUM` in Groonga

  * `LARGE`: `INDEX_LARGE` in Groonga

  * `WITH_WEIGHT`: `WITH_WEIGHT` in Groonga

  * `WEIGHT_FLOAT32`: `WEIGHT_FLOAT32` in Groonga

You can specify multiple flags by separating with `|` such as `LARGE|WITH_WEIGHT`. But you can't specify conflicted flags at once such as `SMALL|MEDIUM|LARGE`.

Normally, you don't need to customize this because the default value is suitable for most cases.

Here is an example to use large index column for large data:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (index_flags_mapping='{
                "content": "LARGE"
              }');
```

[query-v2]:operators/query-v2.html

[groonga-token-bigram]:http://groonga.org/docs/reference/tokenizers.html#token-bigram

[groonga-normalizer-auto]:http://groonga.org/docs/reference/normalizers.html#normalizer-auto

[groonga-table-patricia-trie]:http://groonga.org/docs/reference/tables.html#table-pat-key

[groonga-table-hash-table]:http://groonga.org/docs/reference/tables.html#table-hash-key

[groonga-table-double-array-trie]:http://groonga.org/docs/reference/tables.html#table-dat-key

[unicode-nfkc]:http://unicode.org/reports/tr15/

[mecab]:http://taku910.github.io/mecab/

[groonga-token-ngram]:https://groonga.org/ja/docs/reference/tokenizers/token_ngram.html

[groonga-token-mecab]:http://groonga.org/docs/reference/tokenizers.html#token-mecab

[groonga-token-delimit]:http://groonga.org/docs/reference/tokenizers.html#token-delimit

[groonga-tokenizers]:http://groonga.org/docs/reference/tokenizers.html

[groonga-normalizers]:http://groonga.org/docs/reference/normalizers.html

[groonga-normalizer-table]:https://groonga.org/docs/reference/normalizers/normalizer_table.html

[groonga-token-filters]:http://groonga.org/docs/reference/token_filters.html

[postgresql-tablespace]:{{ site.postgresql_doc_base_url.en }}/manage-ag-tablespaces.html

[text-full-text-search-ops-v2]:./#text-full-text-search-ops-v2

[text-regexp-ops-v2]:./#text-regexp-ops-v2

[text-term-search-ops-v2]:./#text-term-search-ops-v2

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html

[groonga-index-column-flags]:https://groonga.org/docs/reference/commands/column_create.html#flags
