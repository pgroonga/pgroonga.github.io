---
title: "pgroonga_wal_applier.naptimeパラメーター"
upper_level: ../
---

# `pgroonga_wal_applier.naptime`パラメーター

2.3.3で追加。

## 概要

`pgroonga_wal_applier.naptime`パラメーターは[`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]がWALを適用する間隔を制御します。

値を大きくするほど[`pgroonga.max_wal_size`パラメーター][max-wal-size]の値も大きくする必要があります。

値を小さくするほどムダなCPU実行時間が増えます。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_wal_applier.naptime = interval
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

[max-wal-size]:max-wal-size.html
