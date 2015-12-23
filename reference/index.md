---
title: Reference manual
layout: en
---

# Reference manual

This document describes about all features. [Tutorial](../tutorial/) focuses on easy to understand only about important features. This document focuses on completeness. If you don't read [tutorial](../tutorial/) yet, read tutorial before read this document.

## `pgroonga` index

  * [`CREATE INDEX USING pgroonga`](create-index-using-pgroonga.html)

  * [PGroonga versus GiST and GIN](pgroonga-versus-gist-and-gin.html)

  * [`jsonb` support](jsonb.html)

## Operators

  * [`LIKE` operator](operators/like.html)

  * `ILIKE` operator

  * [`%%` operator](operators/match.html)

  * [`@@` operator](operators/query.html) for non `jsonb` types

  * [`@@` operator](operators/jsonb-query.html) for `jsonb` type

  * [`@>` operator](operators/jsonb-contain.html)

  * `@~` operator

## Functions

  * [`pgroonga.score` function](functions/pgroonga-score.html)

  * [`pgroonga.command` function](functions/pgroonga-command.html)

  * [`pgroonga.table_name` function](functions/pgroonga-table-name.html)

## Parameters

  * [`pgroonga.log_type` parameter](parameters/log_type.html)

  * [`pgroonga.log_path` parameter](parameters/log_path.html)

  * [`pgroonga.log_level` parameter](parameters/log_level.html)

  * [`pgroonga.lock_timeout` parameter](parameters/lock_timeout.html)
