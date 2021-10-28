---
title: "pgroonga.enable_crash_safeパラメーター"
upper_level: ../
---

# `pgroonga.enable_crash_safe`パラメーター

2.3.3で追加。

## 概要

`pgroonga.enable_crash_safe`パラメーターはクラッシュセーフ機能を有効にするかどうかを制御します。

`pgroonga.enable_crash_safe`パラメーターに`on`を設定したときは[`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]に[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]を指定しなければいけません。

参考：[クラッシュセーフ][crash-safe]

## 構文

`postgresql.conf`で`pgroonga.enable_crash_safe`を設定しなければいけません。

```text
pgroonga.enable_crash_safe = boolean
```

`boolean`は真偽値です。真偽値には`on`、`off`、`true`、`false`、`yes`、`no`のようなリテラルがあります。

## 使い方

以下はクラッシュセーフ機能を有効にする設定の例です。

```sql
shared_preload_libraries = 'pgroonga_crash_safers'
pgroonga.enable_crash_safe = on
```

## 参考

  * [クラッシュセーフ][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES
