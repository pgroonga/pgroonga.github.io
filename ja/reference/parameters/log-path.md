---
title: "pgroonga.log_pathパラメーター"
upper_level: ../
---

# `pgroonga.log_path`パラメーター

## 概要

`pgroonga.log_path`パラメーターはログのパスを制御します。

このパラメーターは[`pgroonga.log_type`パラメーター](log-type.html)の値が`file`の時だけ有効です。

デフォルト値は`$PGDATA/pgroonga.log`です。

パスに`none`を指定するとログ出力を無効にできます。

## 構文

SQLの場合：

```sql
SET pgroonga.log_path = path;
```

`postgresql.conf`の場合：

```text
pgroonga.log_path = path
```

`path`は文字列の値です。つまり、`'/var/log/pgroonga.log'`のように`path`の値をクォートする必要があるということです。

PGroongaはログを`path`に出力します。

## 使い方

ログを`/var/log/pgroonga.log`に出力する例です。

```sql
SET pgroonga.log_path = '/var/log/pgroonga.log';
```

ログを無効にする例です。

```sql
SET pgroonga.log_path = 'none';
```

## 参考

  * [`pgroonga.log_type`パラメーター][log-type]

  * [ログのフォーマット](http://groonga.org/ja/docs/reference/log.html#format)

[log-type]:log-type.html
