---
title: "pgroonga_crash_safer.max_recovery_threads パラメーター"
upper_level: ../
---

# `pgroonga_crash_safer.max_recovery_threads` パラメーター

3.1.9で追加

## 概要

`pgroonga_crash_safer.max_recovery_threads` パラメーターは壊れたGroongaインデックスを復旧するスレッド数を指定します。


* `0`: デフォルト。シーケンシャルに復旧します。

* `-1`: 環境にあるすべてのCPUを使用して並列に復旧します。

* `1` 以上の数値: 指定された数値のCPUを使用して並列に復旧します。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_crash_safer.max_recovery_threads = number_of_threads
```

## 使い方

すべてのCPUを使用する `-1` を指定する例です。

```text
pgroonga_crash_safer.max_recovery_threads = -1
```

## 参考

  * [`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]

  * [クラッシュセーフ][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html
