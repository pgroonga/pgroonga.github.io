---
title: pgroonga_is_writable関数
upper_level: ../
---

# `pgroonga_is_writable`関数

## 概要

`pgroonga_is_writable`関数はPGroongaのデータを変更できるかどうかを返します。

## 構文

この関数の構文は次の通りです。

```text
bool pgroonga_is_writable()
```

PGroongaのデータを変更できるかどうかを返します。

## 使い方

例です。

```sql
SELECT pgroonga_is_writable();
--  pgroonga_is_writable 
-- ----------------------
--  t
-- (1 row)
```

## 参考

  * [`pgroonga_set_writable`関数][set-writable]

[is-writable]:pgroonga-is-writable.html
