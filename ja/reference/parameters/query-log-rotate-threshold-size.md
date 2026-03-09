---
title: "pgroonga.query_log_rotate_threshold_sizeパラメーター"
upper_level: ../
---

# `pgroonga.query_log_rotate_threshold_size`パラメーター

3.2.3で追加。

## 概要

`pgroonga.query_log_rotate_threshold_size`パラメーターはクエリログのローテーションを制御します。

クエリーログのローテーションの閾値を指定します。クエリーログファイルのサイズが閾値に指定した値以上になると、ローテートされます。

デフォルト値は`0`で、デフォルトではローテートされません。

[`pgroonga.query_log_path`パラメーター][query-log-path]を設定しクエリログを有効にしていなければ、このパラメーターは意味がありません。

## 構文

SQLの場合：

```sql
SET pgroonga.query_log_rotate_threshold_size = size;
```

`postgresql.conf`の場合：

```text
pgroonga.query_log_rotate_threshold_size = size;
```

`size`はサイズです。デフォルトの単位はバイトです。サフィックスを指定することで単位を変更できます。たとえば、MiBを使いたい場合はMBを指定します。

## 使い方

以下は10MiBを指定する例です。

```text
pgroonga.query_log_rotate_threshold_size = 10MB
```

## 参考

* [`pgroonga.query_log_path`パラメーター][query-log-path]

* [Groongaの`--query-log-rotate-threshold-size`オプション][groonga-query-log-rotate-threshold-size]

[query-log-path]:../parameters/query-log-path.html

[groonga-query-log-rotate-threshold-size]:https://groonga.org/ja/docs/reference/executables/groonga.html#cmdoption-groonga-query-log-rotate-threshold-size
