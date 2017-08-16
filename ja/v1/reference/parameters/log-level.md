---
title: "pgroonga.log_levelパラメーター"
upper_level: ../
---

# `pgroonga.log_level`パラメーター

## 概要

`pgroonga.log_level`パラメーターはどのログを記録するかを制御します。

次のログレベルの中からどれかを選びます。

  * `none`
  * `emergency`
  * `alert`
  * `critical`
  * `error`
  * `warning`
  * `notice`
  * `info`
  * `debug`
  * `dump`

このログレベルのリストはログが少ない順から多い順に並んでいます。

デフォルトのログレベルは`notice`です。

## 構文

SQLの場合：

```sql
SET pgroonga.log_level = level;
```

`postgresql.conf`の場合：

```text
pgroonga.log_level = level
```

`level`は列挙型の値です。これは次のどれかの値を選ばないといけないということです。

  * `none`
  * `emergency`
  * `alert`
  * `critical`
  * `error`
  * `warning`
  * `notice`
  * `info`
  * `debug`
  * `dump`

## 使い方

ログを無効にする例です。

```sql
SET pgroonga.log_level = none;
```

ほとんどのログメッセージを有効にする例です。

```sql
SET pgroonga.log_level = debug;
```
