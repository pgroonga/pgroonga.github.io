---
title: "pgroonga.log_level"
layout: ja
---

# `pgroonga.log_level`パラメータ

## 概要

ログレベルを変更します。

## 構文

```sql
set pgroonga.log_level = level
```

`level`はログのレベルです。次の種類を設定できます。上から下にログの情報が多くなります。未指定時の値は`notice`です。

* error
* warning
* notice
* info
* debug
* dump
