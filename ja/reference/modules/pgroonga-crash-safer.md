---
title: pgroonga_crash_saferモジュール
upper_level: ../
---

# `pgroonga_crash_safer`モジュール

2.3.3で追加。

まだ実験的な機能です。

## 概要

`pgroonga_crash_safer`モジュールはクラッシュセーフ機能を提供します。

  * 内部で使っている壊れたGroongaのデータベースをGroongaのWALを使って自動的に復旧します。

  * 内部で使っている壊れたGroongaのデータベースを`REINDEX`を使って自動的に復旧します。

`pgroonga_crash_safer`モジュールはPostgreSQLがクラッシュ後に最初にPGroongaの機能が使われたときに自動リカバリー処理を開始します。PostgreSQL起動時ではないことに注意してください。PostgreSQL起動時にこの自動リカバリー処理を実行したい場合はPostgreSQLがスタートした直後に`SELECT pgroonga_command('status')`などでPGroongaの機能を使うシンプルなSQLを実行してください。

`pgroonga_crash_safer`モジュールを使うには[`pgroonga.enable_crash_safe`パラメーター][enable-crash-safe]に`on`を指定しなければいけないことに注意してください。

## 使い方

`pgroonga_crash_safer`モジュールを使うには次のパラメーターを設定しなければいけません。

  * [`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]

  * [`pgroonga.enable_crash_safe`パラメーター][enable-crash-safe]

例：

```text
shared_preload_libraries = 'pgroonga_crash_safer'
pgroonga.enable_crash_safer = on
```

[`max_worker_processes`パラメーター][postgresql-max-worker-processes]の値を増やさないといけないかもしれません。`pgroonga_crash_safer`モジュールは常に1つワーカープロセスを実行します。さらに、`pgroonga_crash_safer`モジュールはPGroongaを使っているデータベースごとに1つあるいは2つワーカープロセスを実行します。たとえば、もしPGroongaを使っているデータベースが3つあった場合は、`pgroonga_crash_safer`モジュールは最大で7ワーカープロセスを実行します。

```text
max_worker_processes = 15 # 8 (the default) + 7 (for pgroonga_crash_safer)
```

## パラメーター

  * [`pgroonga_crash_safer.flush_naptime`パラメーター][pgroonga-crash-safer-flush-naptime]

  * [`pgroonga_crash_safer.log_level`パラメーター][pgroonga-crash-safer-log-level]

  * [`pgroonga_crash_safer.log_path`パラメーター][pgroonga-crash-safer-log-path]

## 参考

  * [クラッシュセーフ][crash-safe]

[enable-crash-safe]:../parameters/enable-crash-safe.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-crash-safer-flush-naptime]:../parameters/pgroonga-crash-safer-flush-naptime.html
[pgroonga-crash-safer-log-level]:../parameters/pgroonga-crash-safer-log-level.html
[pgroonga-crash-safer-log-path]:../parameters/pgroonga-crash-safer-log-path.html

[crash-safe]:../crash-safe.html
