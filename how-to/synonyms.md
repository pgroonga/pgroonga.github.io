---
title: How to synonyms search
---

## How to synonym search

We need to make a new table for register synonyms to search synonym.

We explain how to register synonyms, delete synonyms, update synonyms, search synonyms, and make a table for register synonyms.

### How to make a new table to register synonyms

We make a table to register synonyms as below.

```sql
CREATE TABLE synonyms (
  term text PRIMARY KEY,
  synonyms text[]
);

CREATE INDEX synonyms_search ON synonyms USING pgroonga (term pgroonga.text_term_search_ops_v2);
```

We can get a term that registered to `synonyms` by using a term that resitered to `term` as key.

For example, If we want to also match "display" when specifying "window" as the search keyword, register "window" to `term` and register "window" and "display" to `synonyms`.
(We attention to need also register target synonym term to `synonyms`.)

We set PGroonga's index to `term` for searching to fast and without uppercase and lowercase.

We can register multiple synonyms into `synonyms`.
Because type of `synonyms` is `text[]`.

### Register synonyms

We can register synonyms by inserting data into `synonyms`.

For example, If we want to register "Window", "display", and "video display" as synonyms, we insert these terms into the table that register synonyms as below.

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('Window', ARRAY['Window', 'display', 'video display']);
INSERT INTO synonyms (term, synonyms) VALUES ('display', ARRAY['display', 'Window', 'video display']);
INSERT INTO synonyms (term, synonyms) VALUES ('video display', ARRAY['video display', 'Window', 'display']);
```

### Add synonyms

How to add synonyms has three patterns.
We explain each method here.

#### Add new synonyms

We can add synonyms in the same way as register synonyms.
For example, If we want to add "copy", "replicate", and "simulate" as synonyms, we insert these terms into the table that register synonyms as below.

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('copy', ARRAY['copy', 'replicate', 'simulate']);
INSERT INTO synonyms (term, synonyms) VALUES ('replicate', ARRAY['replicate', 'copy', 'simulate']);
INSERT INTO synonyms (term, synonyms) VALUES ('simulate', ARRAY['simulate', 'copy', 'replicate']);
```

#### Add new synonyms in existing one

If we want to add new synonyms in the existing one, we update the existing record.
For example, If we also want to match "imitate" when we use "copy" as a search key word.

```sql
UPDATE synonyms SET synonyms = array_append(synonyms, 'imitate') WHERE term = 'copy';
UPDATE synonyms SET synonyms = array_append(synonyms, 'imitate') WHERE term = 'replicate';
UPDATE synonyms SET synonyms = array_append(synonyms, 'imitate') WHERE term = 'simulate';
```

"imitate" is new synonym. Therefour we add record into `synonyms` by using `INSERT` as below.

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('imitate', ARRAY['imitate', 'copy', 'replicate', 'simulate']);
```

#### Modify exist synonyms

If we want to modify an existing record, we update one.
For example, if we want to modify "Windows" to "Window", we as below.

```sql
UPDATE synonyms SET synonyms = array_append(array_remove(synonyms, 'Windows'), 'Window') WHERE term = 'display';
UPDATE synonyms SET synonyms = array_append(array_remove(synonyms, 'Windows'), 'Window') WHERE term = 'video display';
UPDATE synonyms SET synonyms = array_append(array_remove(synonyms, 'Windows'), 'Window') WHERE term = 'Windows';
UPDATE synonyms SET synonyms = array_append(array_remove(term, 'Windows'), 'Window') WHERE term = 'Windows';
```

#### Delete synonyms

If we want to delete synonyms, we can delete record from `synonyms`.
For example, If we want to delete "Window" from synonyms, we as below.

```sql
UPDATE synonyms SET synonyms = array_remove(synonyms, 'Window') WHERE term = 'display';
UPDATE synonyms SET synonyms = array_remove(synonyms, 'Window') WHERE term = 'video display';
DELETE synonyms WHERE term = 'Window';
```

### How to search of synonyms

A search of synonyms uses [`pgroonga_query_expand` function](../reference/functions/pgroonga-query-expand.html).

For example, If we search synonyms of "window", we as below.

First, we make a synonyms table.

```sql
CREATE TABLE synonyms (
  term text PRIMARY KEY,
  synonyms text[]
);

CREATE INDEX synonyms_search ON synonyms USING pgroonga (term pgroonga.text_term_search_ops_v2);
```

Second, we register synonyms into synonyms table.

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('Window', ARRAY['Window', 'display', 'video display']);
INSERT INTO synonyms (term, synonyms) VALUES ('display', ARRAY['display', 'Window', 'video display']);
INSERT INTO synonyms (term, synonyms) VALUES ('video display', ARRAY['video display', 'Window', 'display']);
```

Third, we execute full-text-search with synonyms.

```sql
CREATE TABLE memos (
  id integer,
  content text
);
INSERT INTO memos VALUES (1, 'Window for PC is very low price!!!');
INSERT INTO memos VALUES (2, 'Hight quality video display low price!');
INSERT INTO memos VALUES (3, 'This is junk display.');

CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);

SELECT * FROM memos
  WHERE
    content &@~
      pgroonga_query_expand('synonyms', 'term', 'synonyms', 'Window');

 id |                content                 
----+----------------------------------------
  1 | Window for PC is very low price!!!
  2 | Hight quality video display low price!
  3 | This is junk display.
(3 rows)
```

We use [`pgroonga_query_expand` function](../reference/functions/pgroonga-query-expand.html) to use synonyms search.

See [`pgroonga_query_expand` function](../reference/functions/pgroonga-query-expand.html) for more details.
