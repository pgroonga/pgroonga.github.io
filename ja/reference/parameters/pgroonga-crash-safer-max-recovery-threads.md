---
title: "pgroonga_crash_safer.max_recovery_threads parameter"
upper_level: ../
---

# `pgroonga_crash_safer.max_recovery_threads` parameter

3.1.9で追加

## 概要

`pgroonga_crash_safer.max_recovery_threads` パラメータは壊れたGroongaインデックスの復旧行うスレッド数を指定します。


* `0`: デフォルト。並列リカバリを無効にします。

* `-1`: 環境にあるすべてのCPUを使用して並列リカバリをします。

* `1` 以上の数値: 指定された数値のCPUを使用して並列リカバリをします。

## 構文

`postgresql.conf` の場合

```text
pgroonga_crash_safer.max_recovery_threads = number_of_threads
```

## 使い方

すべてのCPUを使用する `-1` を指定する例です。

```text
pgroonga_crash_safer.max_recovery_threads = -1
```

## 参考

  * [`pgroonga_crash_safer` モジュール][pgroonga-crash-safer]

  * [クラッシュセーフ][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html
