---
title: "pgroonga.log_typeパラメーター"
---

# `pgroonga.log_type`パラメーター

## 概要

`pgroonga.log_type`パラメーターをどのようにログを出力するかを制御します。

以下のどれかのログタイプを選びます。

  * ファイルにログを出力する

  * Windowsイベントログでログを出力する

  * PostgreSQLのログシステムでログを出力する

デフォルトではPGroongaはファイルにログを出力します。ファイルのパスは[`pgroonga.log_path`パラメーター](log-path.html)で指定します。

## 構文

SQLの場合：

```sql
SET pgroonga.log_type = type;
```

`postgresql.conf`の場合：

```text
pgroonga.log_type = type
```

`type`は列挙型の値です。つまり、以下のどれか1つを選ばないといけないということです。

  * `file`：ファイルにログ出力

  * `windows_event_log`：Windowsイベントログでログ出力

  * `postgresql`：PostgreSQLのログシステムでログ出力

## 使い方

以下はPostgreSQLのログシステムを使う例です。

```sql
SET pgroonga.log_type = postgresql;
```

以下はWindowsのイベントログを使う例です。

```sql
SET pgroonga.log_type = windows_event_log;
```

PGroongaのログは[イベントビューアー](http://windows.microsoft.com/ja-jp/windows/open-event-viewer)で確認できます。しかし、イベントビューアーではPGroongaのログは警告付きで表示されるので読みにくいかもしれません。

Windowsに`PGroonga`イベントソースを登録することでイベントビューアーからの警告を消すことができます。

```text
> regsvr32 /n /i:PGroonga ${PostgreSQL install folder}\lib\pgevent.dll
```

[WindowsにおけるEvent Logの登録]({{ site.postgresql_doc_base_url.ja }}/event-log-registration.html)も参照してください。

## 参考

  * [`pgroonga.log_path`パラメーター](log-path.html)
