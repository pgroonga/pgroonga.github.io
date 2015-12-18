---
title: "pgroonga.log_type"
layout: ja
---

# `pgroonga.log_type`パラメータ

## 概要

ログの出力方法を変更する変数を追加しました。ファイル、Windowsイベントログ、PostgreSQLのログ出力機構、のどれかを選べます。

## 構文

```sql
set pgroonga.log_type = type
```

`type`はログの種類です。次の種類を設定できます。未指定時の値は`file`です。

* file: ファイル
* windows_event_log: Windowsイベントログ
* postgresql: PostgreSQLのログ出力機構
