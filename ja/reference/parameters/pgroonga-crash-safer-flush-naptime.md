---
title: "pgroonga_crash_safer.flush_naptimeパラメーター"
upper_level: ../
---

# `pgroonga_crash_safer.flush_naptime`パラメーター

2.3.3で追加。

## 概要

`pgroonga_crash_safer.flush_naptime`パラメーターは[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]のフラッシュ間隔を制御します。

値を大きくするほどGroongaのWALサイズが大きくなります。

値を小さくするほどIO負荷が大きくなります。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_crash_safer.flush_naptime = internval
```

`interval`のデフォルトの単位は秒です。分にしたい場合は`min`といった具合にサフィックスを指定すると単位を変えることができます。

デフォルトは60秒です。

## 使い方

10分を指定する例です。

```text
pgroonga_crash_safer.flush_naptime = 10min
```

## 参考

  * [`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]

  * [クラッシュセーフ][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html
