---
title: "pgroonga_wal_applier.naptime parameter"
upper_level: ../
---

# `pgroonga_wal_applier.naptime` parameter

2.3.3で追加。

## 概要

`pgroonga_wal_applier.naptime` parameter controls application interval by [`pgroonga_wal_applier` module][pgroonga-wal-applier].

The larger value, the larger [`pgroonga.max_wal_size` parameter][max-wal-size] value is required.

The smaller value, the more needless CPU load.

## 構文

`postgresql.conf`の場合：

```text
pgroonga_wal_applier.naptime = internval
```

`interval`のデフォルトの単位は秒です。分にしたい場合は`min`といった具合にサフィックスを指定すると単位を変えることができます。

デフォルトは60秒です。

## 使い方

10分を指定する例です。

```text
pgroonga_wal_applier.naptime = 10min
```

## 参考

  * [`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]

 * [ストリーミングレプリケーション][streaming-replication]

[pgroonga-wal-applier]:../modules/pgroonga-wal-applier.html

[streaming-replication]:../streaming-replication.html
