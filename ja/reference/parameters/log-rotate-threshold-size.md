---
title: "pgroonga.log_rotate_threshold_sizeパラメーター"
upper_level: ../
---

# `pgroonga.log_rotate_threshold_size`パラメーター

3.2.3で追加。

## 概要

`pgroonga.log_rotate_threshold_size`パラメーターはpgroonga.logのローテーションを制御します。

pgroonga.logのローテーションの閾値を指定します。ログファイルのサイズが閾値に指定した値以上になると、ローテートされます。

デフォルト値は`0`で、デフォルトではローテートされません。

[`pgroonga.log_type = file`][log-type]を設定しpgroonga.logを有効にしていなければ、このパラメーターは意味がありません。

## 構文

SQLの場合：

```sql
SET pgroonga.log_rotate_threshold_size = size;
```

`postgresql.conf`の場合：

```text
pgroonga.log_rotate_threshold_size = size;
```

`size`はサイズです。デフォルトの単位はバイトです。サフィックスを指定することで単位を変更できます。たとえば、MiBを使いたい場合はMBを指定します。

## 使い方

以下は10MiBを指定する例です。

```text
pgroonga.log_rotate_threshold_size = 10MB
```

## 参考

* [`pgroonga.log_type`パラメーター][log-type]

* [Groongaの`--log-rotate-threshold-size`オプション][groonga-log-rotate-threshold-size]

[log-type]:../parameters/log-type.html

[groonga-log-rotate-threshold-size]:https://groonga.org/ja/docs/reference/executables/groonga.html#cmdoption-groonga-log-rotate-threshold-size

