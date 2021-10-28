---
title: "pgroonga_crash_safer.log_levelパラメーター"
upper_level: ../
---

# `pgroonga_crash_safer.log_level`パラメーター

2.3.3で追加。

## 概要

`pgroonga_crash_safer.log_level`パラメーターはどのログを記録するかを制御します。これは[`pgroonga.log_level`パラメーター][log-level]の[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]バージョンです。

詳細は[`pgroonga.log_level`パラメーター][log-level]を参照してください。

## 構文

`postgresql.conf`の場合：

```text
pgroonga_crash_safer.log_level = level
```

指定できるレベルは[`pgroonga.log_level`パラメーター][log-level]を参照してください。

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
