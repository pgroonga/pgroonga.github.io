---
title: How to use PGroonga with Railway
---

# How to use PGroonga with Railway

This guide explains how to use the [Railway template](https://railway.com/deploy/pgroonga). The Railway’s scalable infrastructure makes it easy to deploy PGroonga with automatic scaling, persistent storage, and one-click setup.

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

```
CREATE EXTENSION pgroonga;
```

#### Create a full-text search index

Create a column that you want to enable full-text search on, using the **`text`** type.

```
CREATE TABLE memos (
  id integer,
  content text
);
```

Create a PGroonga index on the target column.

```
CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

(Optional) Insert some sample data.

```
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full-text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

Now your setup is complete! You can start running full-text searches instantly.
