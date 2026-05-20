---
title: How to use PGroonga with Railway
---

# How to use PGroonga with Railway

This guide explains how to use the [Railway template](https://railway.com/deploy/pgroonga).
The Railway’s scalable infrastructure makes it easy to deploy PGroonga with persistent storage and one-click setup.

## Implementation Details

### Setup Configuration

This template provides PostgreSQL with the PGroonga extension pre-installed. A TCP proxy is configured to allow access to the database from anywhere, enabling external connections to the PGroonga database.

Please configure the following environment variables according to your environment:

* POSTGRES_USER
* POSTGRES_PASSWORD
* POSTGRES_DB

### Database Connection

Use the DATABASE_URL variable from your Railway service to connect to the PGroonga database.

```
$ psql $DATABASE_URL
```

Or, if you want to reference it from another Railway service's variable, you can use it as the [reference variables](https://docs.railway.com/variables#referencing-another-services-variable-example):

```
${{PGroonga.DATABASE_URL}}
```

### How To Use

Once connected, enable the PGroonga extension using the following SQL:

```sql
CREATE EXTENSION pgroonga;
```

#### Create a full-text search index

Create a table with a **`text`** column that you want to enable full-text search on.

```sql
CREATE TABLE memos (
  id integer,
  content text
);
```

Create a full-text search index with PGroonga on the target column.

```sql
CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

(Optional) Insert some sample data.

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full-text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

Run a full-text search query.

```sql
SELECT * FROM memos WHERE content &@~ 'groonga';
--  id |                                content
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full-text search engine that supports all languages.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   4 | There is groonga command.
-- (3 rows)
```

Now your setup is complete! You can start running full-text searches instantly.
