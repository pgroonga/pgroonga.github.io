---
title: PGroonga versus GiST and GIN
---

# PGroonga versus GiST and GIN

PostgreSQL provides GiST and GIN as bundled indexes. You can use them for full text search against languages that use only alphabet and digit such as English. You can't use them for full text search against Japanese, Chinese and so on.

PGroonga's main feature is fast full text search against all languages. But PGroonga also provides general propose index features for equality condition and comparison conditions. PGroonga provides more features rather than GiST and GIN. So you can use PGroonga as alternative of GiST and GIN.

This document describes about difference between PGroonga, GiST and GIN.

## Characteristics

[PostgreSQL document describes about characteristics of GiST and GIN]({{ site.postgresql_doc_base_url.en }}/textsearch-indexes.html). In short, searching by GiST is slower than searching by GIN but updating GiST is faster than updating GIN. GIN uses more disk space than GiST.

Searching by PGroonga is faster than GIN and updating PGroonga is faster than GiST. But PGroonga uses more disk space than GIN and GiST.

Here is a table that shows the above characteristics:

Index    | Search      | Update      | Disk usage
-------- | ----------- | ----------- | ----------
GIN      | Faster      | Slower      | Larger
GiST     | Slower      | Faster      | Smaller
PGroonga | More faster | More faster | More larger

## Benchmark

See the following documents for PGroonga and GIN characteristics:

  * [PGroonga versus textsearch and pg\_trgm](pgroonga-versus-textsearch-and-pg-trgm.html)

  * [PGroonga versus pg\_bigm](pgroonga-versus-pg-bigm.html)
