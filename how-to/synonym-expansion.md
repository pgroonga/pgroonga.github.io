---
title: How to use synonym expansion
---

## How to use synonym expansion

We need to make a new table for registering synonyms to search synonym.

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

We can get a term that is registered in `synonyms` with a key that is registered in `term`. 

For example, if we want to also match "display" when specifying "window" as the search keyword, register "window" to `term` and register "window" and "display" to `synonyms`.
Note that we attention to need also register target synonym term to `synonyms`.

We set up PGroonga's index to be able to run fast search `term` without case-sensitivity.

We can register multiple synonyms into `synonyms` because type of `synonyms` is `text[]`.

### Register synonyms

We can register synonyms by inserting data into `synonyms`.

For example, if we want to register "Window", "display", and "video display" as synonyms, we can insert these terms into the table that registers synonyms as below.

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('Window', ARRAY['Window', 'display', 'video display']);
INSERT INTO synonyms (term, synonyms) VALUES ('display', ARRAY['display', 'Window', 'video display']);
INSERT INTO synonyms (term, synonyms) VALUES ('video display', ARRAY['video display', 'Window', 'display']);
```

### Add synonyms

There are three patterns to add synonyms.

#### Add new synonyms

We can add synonyms in the same way as register synonyms.
For example, if we want to add "copy", "replicate", and "simulate" as synonyms, we insert these terms into the table that registers synonyms as below.

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('copy', ARRAY['copy', 'replicate', 'simulate']);
INSERT INTO synonyms (term, synonyms) VALUES ('replicate', ARRAY['replicate', 'copy', 'simulate']);
INSERT INTO synonyms (term, synonyms) VALUES ('simulate', ARRAY['simulate', 'copy', 'replicate']);
```

#### Add new synonyms in existing one

If we want to add new synonyms in the existing one, we update the existing record.
For example, if we also want to match "imitate" when we use "copy" as a search key word.

```sql
UPDATE synonyms SET synonyms = array_append(synonyms, 'imitate') WHERE term = 'copy';
UPDATE synonyms SET synonyms = array_append(synonyms, 'imitate') WHERE term = 'replicate';
UPDATE synonyms SET synonyms = array_append(synonyms, 'imitate') WHERE term = 'simulate';
```

"imitate" is new synonym. Therefore we add record into `synonyms` by using `INSERT` as below.

```sql
INSERT INTO synonyms (term, synonyms) VALUES ('imitate', ARRAY['imitate', 'copy', 'replicate', 'simulate']);
```

#### Modify exist synonyms

If we want to modify an existing record, we can modify it with UPDATE statement.
For example, if we want to modify "Windows" to "Window", we do as below.

```sql
UPDATE synonyms SET synonyms = array_replace(synonyms, 'Windows', 'Window') WHERE term = 'display' OR term = 'video display' OR term = 'Windows';
UPDATE synonyms SET term = 'Window' WHERE term = 'Windows';
```

#### Delete synonyms

If we want to delete existing synonyms, we can delete record from `synonyms`.
For example, if we want to delete "Window" from synonyms, we as below.

```sql
UPDATE synonyms SET synonyms = array_remove(synonyms, 'Window');
DELETE synonyms WHERE term = 'Window';
```

### How to search of synonyms

To search of synonyms uses [`pgroonga_query_expand` function][pgroonga_query_expand].

See [`pgroonga_query_expand` function][pgroonga_query_expand] for more details.

For example, if we search synonyms of "window", we do as below.

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

[pgroonga_query_expand]:../reference/functions/pgroonga-query-expand.html
