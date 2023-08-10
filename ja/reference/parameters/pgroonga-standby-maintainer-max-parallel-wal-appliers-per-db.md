---
title: "pgroonga_standby_maintainer.max_parallel_wal_appliers_per_dbパラメーター"
upper_level: ../
---

# `pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db`パラメーター

3.1.2で追加。

## 概要

`pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db`パラメーターは[`pgroonga_standby_maintainer`モジュール][pgroonga-standby-maintainer]による[`pgroonga_wal_apply()`関数][pgroonga-wal-apply]実行の並列度を制御します。

この値が1以上の場合、各PGroongaインデックスに対する`pgroonga_wal_apply()`は新しいバックグランドワーカープロセスが実行します。並列に`pgroonga_wal_apply()`を実行するために十分なリソースがある場合は、6のように大きな値を指定することでトータルのWAL適用時間を削減できます。

このパラメーターに大きな値を指定した場合、[`max_worker_processes`][postgresql-max-worker-processes]も増やさなければいけないことに注意してください。大きな値を指定した場合、同時にたくさんのワーカープロセスが必要になるかもしれません。

このパラメーターはデータベース単位の並列度を制御することに注意してください。もし、PGroongaを使っているデータベースが2つあり、このパラメーターに6を指定した場合、`pgroonga_wal_apply()`用に同時に12個のバックグランドワーカープロセスが起動するかもしれません。

デフォルト値は0です。これは`pgroonga_wal_apply()`はシーケンシャルに実行するという意味になります。追加のバックグランドワーカープロセスは使われません。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db = max
```

`max`は0あるいは正の整数です。並列度を制御します。

デフォルトは0です。

## 使い方

以下はデータベースごとに並列`pgroonga_wal_apply()`のために最大で6ワーカーを使う例です。

```text
pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db = 6
```

## 参考

  * [`pgroonga_standby_maintainer`モジュール][pgroonga-standby-maintainer]

  * [`pgroonga_wal_apply()`関数][pgroonga-wal-apply]

  * [`max_worker_processes`パラメーター][postgresql-max-worker-processes]

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES
