---
title: "pgroonga.lock_timeoutパラメーター"
layout: ja
---

# `pgroonga.lock_timeout`パラメーター

## 概要

`pgroonga.lock_timeout`パラメーターはロックのタイムアウトを制御します。

PGroongaはロックを獲得するまで、1ミリ秒おきに指定したタイムアウト回数だけロックを獲得しようとします。

デフォルト値は`10000000`です。これは、PGroongaはデフォルトではロックを獲得するまで約2.7時間ロック獲得を試みるということです。

## 構文

SQLの場合：

```sql
SET pgroonga.lock_timeout = timeout;
```

`postgresql.conf`の場合：

```text
pgroonga.lock_timeout = timeout
```

`timeout`は数値です。

## 使い方

以下は1分（`1ミリ秒 * 60000 = 60000ミリ秒 = 60秒 = 1分`）でロックを獲得できなかったらロック獲得を諦めるようにする例です。

```sql
SET pgroonga.lock_timeout = 60000;
```
