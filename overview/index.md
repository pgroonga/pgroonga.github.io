---
title: Overview
---

# Overview

PGroonga is a PostgreSQL extension. PGroonga provides a new index access method that uses [Groonga](http://groonga.org/).

Groonga is an embeddable super fast full text search engine. It can be embedded into MySQL. [Mroonga](http://mroonga.org/) is a storage engine that is based on Groonga. Groonga can also work as standalone search engine. 

PostgreSQL supports full text search against languages that use only alphabet and digit. It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on. You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL!

And more, PGroonga supports full text search against all text values in JSON. It's an unique feature. Built-in PostgreSQL features and [JsQuery](https://github.com/postgrespro/jsquery) don't support it.

## Related extensions

There are some extensions that implements full text search against all languages:

  * [pg_trgm](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/pgtrgm.html)
    * It's bundled with PostgreSQL but it's not installed as default.
    * You need to change pg\_trgm source code to support all languages.

  * [pg_bigm](http://pgbigm.osdn.jp/)
    * It supports full text search against all languages without changing source code.
    * It requires [Recheck](http://pgbigm.osdn.jp/pg_bigm_en-1-1.html#enable_recheck) to remove false positives.
    * Recheck is slow for many hits case. Because Recheck does sequential search against records found by index search.
    * If you disables Recheck, you may get false positives.

PGroonga supports full text search against all languages without changing source code.

PGroonga works without Recheck. PGroonga can find exact records only by index search. PGroonga is fast for many hits case.

PGroonga doesn't support crash recovery and streaming replication because PGroonga doesn't support WAL. Because PostgreSQL doesn't provide API for supporting WAL to extensions. PGroonga will support WAL when PostgreSQL provides the API.

FYI: pg\_trgm and pg\_bigm support WAL. To be precise, GIN and GiST that are used by pg\_trgm and pg\_bigm support WAL.

## History

PGroonga is based on [textsearch_groonga](http://textsearch-ja.projects.pgfoundry.org/textsearch_groonga.html) that was developed by Itagaki Takahiro. Thanks for the works!

## The next step

Interested? [Install](../install/) PGroonga and try [tutorial](../tutorial/). You can understand more about PGroonga.
