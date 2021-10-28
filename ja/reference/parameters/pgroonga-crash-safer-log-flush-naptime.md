---
title: "pgroonga_crash_safer.flush_naptimeパラメーター"
upper_level: ../
---

# `pgroonga_crash_safer.flush_naptime`パラメーター

2.3.3で追加。

## 概要

`pgroonga_crash_safer.flush_naptime`パラメーターは[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]のフラッシュ間隔を制御します。

値を大きくするほどGroongaのWALサイズが大きくなります。

The shorter value, the heavier IO load.

## 構文

`postgresql.conf`の場合：

```text
pgroonga_crash_safer.flush_naptime = internval
```

`interval`'s unit is second. The default is 60 seconds.

## 使い方

ログを無効にする例です。

```text
pgroonga_crash_safer.log_level = none
```

ほとんどのログメッセージを有効にする例です。

```sql
pgroonga_crash_safer.log_level = debug
```

## 参考

  * [`pgroonga.log_level`パラメーター][log-level]

  * [`pgroonga_crash_safer.log_path`パラメーター][pgroonga-crash-safer-log-path]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[log-level]:log-level.html

[pgroonga-crash-safer-log-path]:pgroonga-crash-safer-log-path.html
