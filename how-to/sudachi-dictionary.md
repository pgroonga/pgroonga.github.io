---
title: How to use Sudachi dictionary for synonym expansion
---

## How to use Sudachi dictionary for synonym expansion

[SudachiDict][sudachi-dict] provides a synonym dictionary. We can use it in PGroonga.

We explain how to use the synonym dictionary in SudachiDict in your search system. We use the synonym dictionary in SudachiDict as the system dictionary here. We can use additional synonym dictionary defined by us.

### How to register contents of the synonym dictionary in SudachiDict

We need to create a table for system synonym dictionary based on SudachiDict. We name it `system_thesaurus` here:

```sql
CREATE TABLE system_thesaurus (
  term text PRIMARY KEY,
  synonyms text[]
);
```

We need a PGroonga index to use it as synonym dictionary. It must use `pgroonga_text_term_search_ops_v2` operator class for `term` that is used as synonym key:

```sql
CREATE INDEX system_thesaurus_term_index
  ON system_thesaurus
  USING pgroonga (term pgroonga_text_term_search_ops_v2);
```

We can use [Groonga synonym][groonga-synonym] to register contents of the synonym dictionary in SudachiDict to `system_thesaurus`.

Groonga synonym is written in Ruby. We need to install Ruby at first.

Install Groonga synonym:

```bash
gem install groonga-synonym
```

The following command line generates `INSERT` to register contents of the synonym dictionary in SudachiDict to `system_thesaurus`:

```bash
groonga-synonym-generate --format=pgroonga --table=system_thesaurus --output=system_thesaurus_data.sql
```

The generated data has weight because SudachiDict provides relation information. 

We can load the data by `\i` in `psql`:

```text
\i system_thesaurus_data.sql
```

### How to register user synonym dictionary

We need to create a table for user synonym dictionary. We use [synonym groups usage][pgroonga-query-expand-usage-synonym-groups] here. Because maintaining synonym dictionary is high cost task. Synonym groups usage is less maintenance cost than [term to synonyms usage][pgroonga-query-expand-usage-term-to-synonyms].

We name it `user_synonym_groups` here:

```sql
CREATE TABLE user_synonym_groups (
  synonyms text[]
);
```

We need a PGroonga index to use it as synonym dictionary. It must use `pgroonga_text_array_term_search_ops_v2` operator class for `synonyms` that is used as synonym group:

```sql
CREATE INDEX user_synonym_groups_synonyms_index
          ON user_synonym_groups
       USING pgroonga (synonyms pgroonga_text_array_term_search_ops_v2);
```

Here are sample data:

```sql
INSERT INTO user_synonym_groups VALUES (ARRAY['pg', 'postgresql']);
```

We can get the same search result for `pg` and `postgresql` with this synonym groups data. If we search with `pg`, `pg OR postgresql` is used as query. If we search with `postgresql`, `pg OR postgresql` is used as query.

### How to search with synonym dictionaries

We can use [`pgroonga_query_expand` function][pgroonga-query-expand] twice to search with synonym dictionaries.

First `pgroonga_query_expand()` uses user synonym dictionary:

```sql
SELECT
  pgroonga_query_expand(
    'user_synonym_groups',
    'synonyms',
    'synonyms',
    'QUERY'
  );
```

Here is an example to use `pg` as query:

```sql
SELECT
  pgroonga_query_expand(
    'user_synonym_groups',
    'synonyms',
    'synonyms',
    'pg'
  );
--  pgroonga_query_expand  
-- ------------------------
--  ((pg) OR (postgresql))
-- (1 row)
```

Both of `pg` and `postgresql` will be searched.

Second `pgroonga_query_expand()` uses system synonym dictionary against the result of the first `pgroonga_query_expand()`:

```sql
SELECT
  pgroonga_query_expand(
    'system_thesaurus',
    'term',
    'synonyms',
    pgroonga_query_expand(
      'user_synonym_groups',
      'synonyms',
      'synonyms',
      'QUERY'
    )
  );
```

We add one more synonym group to the user synonym dictionary:

```sql
INSERT INTO user_synonym_groups VALUES (ARRAY['on-line', 'online']);
```

Let's confirm the new synonym group:

```sql
SELECT
  pgroonga_query_expand(
    'user_synonym_groups',
    'synonyms',
    'synonyms',
    'on-line'
  );
--   pgroonga_query_expand  
-- -------------------------
--  ((on-line) OR (online))
-- (1 row)
```

Let's use both system synonym dictionary and user synonym dictionary with `on-line` as query:

```sql
SELECT
  pgroonga_query_expand(
    'system_thesaurus',
    'term',
    'synonyms',
	pgroonga_query_expand(
      'user_synonym_groups',
      'synonyms',
      'synonyms',
      'on-line'
    )
  );
--               pgroonga_query_expand               
-- --------------------------------------------------
--  ((on-line) OR (((>-0.2オンライン) OR (online))))
-- (1 row)
```

Here is the workflow of the above `SELECT`:

  1. `on-line` is expanded to `on-line OR online` with user synonym dictionary: `on-line` -> `((on-line)) OR (online))`

  2. `online` is expanded to `>-0.2オンライン OR online` with system synonym dictionary: `((on-line)) OR (online))` -> `((on-line) OR (((>-0.2オンライン) OR (online))))`

Note that `>-0.2` in `>-0.2オンライン` adjusts weight for `オンライン`. It uses `0.8` (`1 - 0.2`) as weight.

Let's use the synonym dictionaries with full text search:

```sql
CREATE TABLE memos (
  content text
);
INSERT INTO memos VALUES ('Online conference is easy to join');
INSERT INTO memos VALUES ('On-line conference is easy to join');
INSERT INTO memos VALUES ('オンライン conference is easy to join');

CREATE INDEX memos_content_index ON memos USING pgroonga (content);

-- For ensuring using index
SET enable_seqscan = no;

SELECT content, pgroonga_score(tableoid, ctid) AS score
  FROM memos
  WHERE
    content &@~
      pgroonga_query_expand(
        'system_thesaurus',
        'term',
        'synonyms',
        pgroonga_query_expand(
          'user_synonym_groups',
          'synonyms',
          'synonyms',
          'on-line'
        )
      );
--                content                |       score       
-- ---------------------------------------+-------------------
--  On-line conference is easy to join    |                 1
--  オンライン conference is easy to join | 0.800000011920929
--  Online conference is easy to join     |                 1
-- (3 rows)
```

[sudachi-dict]:https://github.com/WorksApplications/SudachiDict

[groonga-synonym]:https://github.com/groonga/groonga-synonym

[pgroonga-query-expand-usage-synonym-groups]:../reference/functions/pgroonga-query-expand.html#usage-synonym-groups

[pgroonga-query-expand-usage-term-to-synonyms]:../reference/functions/pgroonga-query-expand.html#usage-term-to-synonyms

[pgroonga-query-expand]:../reference/functions/pgroonga-query-expand.html
