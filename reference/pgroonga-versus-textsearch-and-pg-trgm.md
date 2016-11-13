---
title: PGroonga versus textsearch and pg_trgm
---

# PGroonga versus textsearch and pg\_trgm

PostgreSQL provides two full text search modules. They are [textsearch]({{ site.postgresql_doc_base_url.en }}/textsearch.html) and [pg\_trgm]({{ site.postgresql_doc_base_url.en }}/pgtrgm.html).

The textsearch module is a built-in full text search feature. It supports GiST and GIN indexes. If you use GiST or GIN index, you can improve full text search performance.

The pg\_trgm module is a contrib module. pg\_trgm provides full text search feature. pg\_trgm also supports GiST and GIN indexes. If you use GiST or GIN index, you can improve full text search performance.

This documents describes about difference between PGroonga, textsearch and pg\_trgm.

## Characteristics

Here are characteristics of each modules.

### The textsearch module {#textsearch}

The textsearch module implements language specific full text search. For example, English terms are stemmed. All of "work", "works" and "worked" are converted to "work". It'll improve [recall](https://en.wikipedia.org/wiki/Full-text_search#The_precision_vs._recall_tradeoff).

Language specific full text search may improve full text search feature but "language specific" means someone implements "language specific" process. PostgreSQL 9.6.1 supports 15 languages such as English, French and Russian but other many languages aren't supported such as Asian languages including Japanese, Chinese and Korean.

The textsearch module is fast for searching because it doesn't need "recheck". (If you use weight, you need "recheck".)

The textsearch module can't process very large text. `1MiB - 1B` is the max bytes of text. If you put 1MiB or more text, you will get the following error:

```text
string is too long for tsvector (XXX bytes, max 1048575 bytes)
```

### The pg\_trgm module {#pg-trgm}

The pg\_trgm module implements not language specific full text search. But pg\_trgm disables non ASCII characters support. It means that pg\_trgm doesn't support many Asian languages such as Japanese and Chinese by default. You need to comment out the following line in `contrib/pg_trgm/trgm.h` to enable non ASCII characters support:

```c
#define KEEPONLYALNUM
```

If you're using Debian based system, you can enable non ASCII characters support without changing pg\_trgm source code by using `C.UTF-8` locale.

The pg\_trgm module is slow when many documents are matched and each document is long. Because pg\_trgm need "recheck" after index search.

### PGroonga {#pgroonga}

PGroonga implements both language specific full text search and not language specific full text search. PGroonga uses not language specific full text search by default. Normally, PGroonga provides satisfactory full text search result by default.

PGroonga supports all languages by default because PGroonga uses not language specific full text search by default. You don't need to change source code.

PGroonga is fast for searching because it doesn't need "recheck".

PGroonga is also fast for searching while updating because it doesn't block searching while updating. PGroonga doesn't decrease search performance while updating.

PGroonga is also fast for updating.

PGroonga index is large because it keeps index target text that is already stored in PostgreSQL.

### Summary {#summary}

Module     | Supported languages                  | Search  | Update  | Size
---------- | ------------------------------------ | ------- | ------- | -------
textsearch | 15 (Asian languages aren't included) | Faster  | Slower  | Smaller
pg\_trgm   | ASCII only languages                 | Slower  | Slower  | Smaller
PGroonga   | All                                  | Faster  | Faster  | Larger

## Benchmark {#benchmark}

TODO
