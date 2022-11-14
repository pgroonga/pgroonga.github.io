---
title: "pgroonga_standby_maintainer.naptime パラメーター"
upper_level: ../
---

# `pgroonga_standby_maintainer.naptime` パラメーター

2.4.2で追加。

## 概要

`pgroonga_standby_maintainer.naptime` パラメーターは [`pgroonga_standby_maintainer` モジュール][pgroonga-standby-maintainer]による、[`pgroonga_wal_apply()` 関数][pgroonga-wal-apply] と [`pgroonga_vacuum()` 関数][pgroonga-vacuum] の実行間隔を制御します。

値を大きくするほど、スタンバイのデータベースで未適用のPGroongaのWALと、使われていないGroongaのテーブルやカラム、レコードが増加します。

値を小さくするほどIO負荷が大きくなります。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_standby_maintainer.naptime = internval
```

`interval` のデフォルトの単位は秒です。サフィックスを `min` に指定することで単位を分に変えることができます。

デフォルトは60秒です。

## 使い方

10分を指定する例です。

```text
pgroonga_standby_maintainer.naptime = 10min
```

## 参考

  * [`pgroonga_standby_maintainer` モジュール][pgroonga-standby-maintainer]
  * [`pgroonga_wal_apply()` 関数][pgroonga-wal-apply]
  * [`pgroonga_vacuum()` 関数][pgroonga-vacuum]

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html

[pgroonga-vacuum]:../functions/pgroonga-vacuum.html
