---
title: "pgroonga.query_log_pathパラメーター"
upper_level: ../
---

# `pgroonga.query_log_path`パラメーター

## 概要

`pgroonga.query_log_path`パラメーターはクエリーログのパスを管理します。

[`pgroonga_command`関数](../functions/pgroonga-command.html)を使っていないのならこのパラメーターは意味がありません。なぜならクエリーは`pgroonga_command`関数経由でしか実行できないからです。

相対パスを指定した場合は、`$PGDATA`を基準にしてパスを解決します。

パスに`none`を指定することでクエリーログを無効にできます。

デフォルト値は`none`です。つまり、デフォルトではクエリーログは無効です。

## 構文

SQLの場合：

```sql
SET pgroonga.query_log_path = path;
```

`postgresql.conf`の場合：

```text
pgroonga.query_log_path = path
```

`path`は文字列値です。`'pgroonga.query.log'`というように`path`の値をクォートする必要があるということです。

PGroongaはクエリーログを`path`に出力します。

## 使い方

以下はクエリーログを`$PGDATA/pgroonga.query.log`に出力する例です。

```sql
SET pgroonga.query_log_path = 'pgroonga.query.log';
```

以下はクエリーログを`/var/log/pgroonga.query.log`に出力する例です。

```sql
SET pgroonga.query_log_path = '/var/log/pgroonga.query.log';
```

以下はクエリーログを無効にする例です。

```sql
SET pgroonga.query_log_path = 'none';
```

## 参考

  * [クエリーログのフォーマット](http://groonga.org/ja/docs/reference/log.html#query-log)
