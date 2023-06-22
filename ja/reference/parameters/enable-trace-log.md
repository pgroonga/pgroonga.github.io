---
title: "pgroonga.enable_trace_logパラメーター"
upper_level: ../
---

# `pgroonga.enable_trace_log`パラメーター

3.0.8で追加。

## 概要

`pgroonga.enable_trace_log`パラメーターはトレースログを有効にするかどうかを制御します。

トレースログを有効にするとPGroongaの性能が落ちます。

トレースログは`NOTICE`レベルのログとして出力されます。

デフォルト値は`off`です。これはトレースログは出力されないということです。

## 構文

SQLの場合：

```sql
SET pgroonga.enable_trace_log = boolean;
```

`postgresql.conf`の場合：

```text
pgroonga.enable_trace_log = boolean
```

`boolean`は真偽値です。真偽値には`on`、`off`、`true`、`false`、`yes`、`no`のようなリテラルがあります。

## 使い方

以下はトレースログを有効にするSQLの例です。

```sql
SET pgroonga.enable_trace_log = on;
```

以下はトレースログを有効にする設定の例です。

```sql
pgroonga.enable_trace_log = on
```

## 参考

  * [`pgroonga.log_level`パラメーター][log-level]

[log-level]:log-level.html
