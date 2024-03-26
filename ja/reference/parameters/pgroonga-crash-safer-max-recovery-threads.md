---
title: "pgroonga_crash_safer.max_recovery_threads parameter"
upper_level: ../
---

# `pgroonga_crash_safer.max_recovery_threads` parameter

3.1.9で追加

## 概要

`pgroonga_crash_safer.max_recovery_threads` パラメータは壊れたGroongaインデクスの復旧行うスレッド数を指定します。

* デフォルトは `0` でこれは無効を意味します
* 環境にあるすべてのCPUを使う場合は `-1` を設定します
* `1` 以上の値を設定すると、設定された数のCPUを使います

## 構文

`postgresql.conf` の場合

```text
pgroonga_crash_safer.max_recovery_threads = number_of_threads
```

## 使い方

`-1` を指定する例です。

```text
pgroonga_crash_safer.max_recovery_threads = -1
```

## 参考

  * [`pgroonga_crash_safer` モジュール][pgroonga-crash-safer]

  * [クラッシュセーフ][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html
