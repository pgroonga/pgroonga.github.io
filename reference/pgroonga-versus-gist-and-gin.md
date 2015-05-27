---
title: PGroonga versus GiST and GIN
layout: en
---

# PGroonga versus GiST and GIN

PostgreSQL provides GiST and GIN as bundled indexes. PGroonga's main feature is CJK ready fast full text search. But PGroonga also provides general propose index features for equality condition and comparison conditions. You can use PGroonga as alternative of GiST and GIN.

This documents describes about different between PGroonga, GiST and GIN.

## Characteristics

[PostgreSQL document describes about characteristics of GiST and GIN](http://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/textsearch-indexes.html). In short, searching by GiST is slower than searching by GIN but updating GiST is faster than updating GIN. GIN uses more disk space than GiST.

Searching by PGroonga is faster than GIN and updating PGroonga is faster than GiST. But PGroonga uses more disk space than GIN and GiST.

Here is a table that shows the above characteristics:

Index    | Search      | Update      | Disk usage
-------- | ----------- | ----------- | ----------
GIN      | Faster      | Slower      | Larger
GiST     | Slower      | Faster      | Smaller
PGroonga | More faster | More faster | More larger

## Benchmark

This section shows these characteristics by sample data.

TODO
