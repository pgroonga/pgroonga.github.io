---
title: "pgroonga.lock_timeout"
layout: ja
---

# `pgroonga.lock_timeout`パラメータ

## 概要

 ロック獲得時のリトライ数を変更する変数です。

## 構文

```sql
set pgroonga.lock_timeout = timeout
```

`timeout`はロックタイムアウトの時間です。単位はXXです。単位は未指定時の値は`10000000`です。
