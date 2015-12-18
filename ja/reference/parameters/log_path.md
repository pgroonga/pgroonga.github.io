---
title: "pgroonga.log_path"
layout: ja
---

# `pgroonga.log_path`パラメータ

## 概要

ファイルにログを出力するときの出力先のファイル名を変更する変数です。`log_type`が`file`の場合のみ有効なパラメータです。

## 構文

```sql
set pgroonga.log_path = path
```

`path`はログファイルのパスです。未指定時は`$PGDATA/pgroonga.log`です。
